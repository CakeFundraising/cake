class CampaignCakester < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :cakester
  belongs_to :cakester_request

  delegate :status, to: :cakester_request, allow_nil: true

  scope :regular, ->{ where(kind: :regular) }
  scope :exclusive, ->{ where(kind: :exclusive) }

  scope :with_campaign, ->{ eager_load(:campaign) }

  before_save do
    self.kind = self.cakester_request_id.nil? ? :regular : :exclusive
  end

  after_destroy :destroy_cakester_request

  def regular?
    self.kind == 'regular'
  end

  def exclusive?
    self.kind == 'exclusive'
  end

  private

  def destroy_cakester_request
    self.cakester_request.destroy if self.cakester_request.present?
  end
end
