class CakesterRequest < ActiveRecord::Base
  include Statusable
  has_statuses :pending, :accepted, :rejected, :past

  belongs_to :cakester
  belongs_to :campaign
  belongs_to :fundraiser

  validates :cakester, :campaign, :fundraiser, presence: true
  validates :cakester_id, uniqueness: {scope: [:campaign_id, :fundraiser_id]}

  scope :latest, ->{ order(created_at: :desc) }
  scope :pending_or_accepted, ->{ where("cakester_requests.status = ? OR cakester_requests.status = ?", :pending, :accepted) }

  delegate :main_cause, :scopes, :cakester_commission_percentage, :hero, to: :campaign 

  after_create :notify_cakester
  after_destroy :rollback_campaign

  def accept!
    notify_approval if self.accepted!
  end

  def reject!(message)
    if self.rejected!
      notify_rejection(message)
      rollback_campaign
    end
  end

  private

  def rollback_campaign
    self.campaign.update_attributes(uses_cakester: false, cakester_id: nil)
  end

  def notify_cakester
    cakester.users.each do |user|
      #CakesterNotification.new_cakester_request(self.id, user.id).deliver if user.cakester_email_setting.new_cakester_request
      CakesterNotification.new_cakester_request(self.id, user.id).deliver
    end
  end

  def notify_approval
    fundraiser.users.each do |user|
      #PledgeNotification.accepted_cakester_request(self.id, user.id).deliver if user.fundraiser_email_setting.reload.accepted_cakester_request
      CakesterNotification.accepted_cakester_request(self.id, user.id).deliver
    end
  end

  def notify_rejection(message)
    fundraiser.users.each do |user|
      CakesterNotification.rejected_cakester_request(self.id, user.id, message).deliver
    end
  end
end
