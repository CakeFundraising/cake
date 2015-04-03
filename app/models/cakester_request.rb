class CakesterRequest < ActiveRecord::Base
  include Statusable

  has_statuses :pending, :accepted, :rejected, :past

  belongs_to :cakester
  belongs_to :campaign
  belongs_to :fundraiser
  has_one :campaign_cakester, dependent: :destroy

  has_one :commission, through: :campaign, source: :cakester_commission_setting

  has_one :pledge, ->(cc){ where(campaign_id: cc.campaign_id) }, through: :cakester, class_name:'Pledge', source: :pledges

  validates :cakester, :campaign, :fundraiser, :message, presence: true
  validates :cakester_id, uniqueness: {scope: [:campaign_id, :fundraiser_id]}

  scope :latest, ->{ order(created_at: :desc) }
  scope :from_campaign, ->(campaign){ where(campaign: campaign) }
  scope :pending_or_accepted, ->{ where("cakester_requests.status = ? OR cakester_requests.status = ?", :pending, :accepted) }

  delegate :main_cause, :scopes, :hero, to: :campaign 

  before_validation do
    self.fundraiser = self.campaign.fundraiser
  end

  after_create :update_campaign, :notify_cakester
  after_destroy :rollback_campaign

  def accept!
    if self.accepted!
      notify_approval
      create_campaign_cakester
    end
  end

  def reject!(message)
    if self.rejected!
      notify_rejection(message)
      rollback_campaign
    end
  end

  def notify_termination(message, terminated_by_id)
    users = fundraiser.users + cakester.users
    users.each do |user|
      CakesterNotification.terminated_cakester_request(self.campaign.id, user.id, terminated_by_id, message).deliver
    end
  end

  private

  def create_campaign_cakester
    self.build_campaign_cakester(campaign_id: self.campaign_id, cakester_id: self.cakester_id).save
    self.campaign.update_attribute(:exclusive_cakester_id, self.cakester_id) #Set up campaign's exclusive cakester
  end

  def update_campaign
    self.campaign.update_attributes(uses_cakester: true, any_cakester: false)
  end

  def rollback_campaign
    self.campaign.update_attributes(uses_cakester: false, exclusive_cakester_id: nil)
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
