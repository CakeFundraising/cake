class CampaignCakester < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :cakester
  belongs_to :cakester_request

  delegate :status, to: :cakester_request, allow_nil: true

  before_save do
    self.kind = self.cakester_request_id.nil? ? :regular : :exclusive
  end

  scope :regular, ->{ where(kind: :regular) }
  scope :exclusive, ->{ where(kind: :exclusive) }

  scope :with_campaign, ->{ eager_load(:campaign) }

  def regular?
    self.kind == 'regular'
  end

  def exclusive?
    self.kind == 'exclusive'
  end
end
