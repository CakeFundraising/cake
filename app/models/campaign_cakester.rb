class CampaignCakester < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :cakester
  belongs_to :cakester_request

  has_one :pledge, ->(cc){ where(campaign_id: cc.campaign_id) }, through: :cakester, class_name:'Pledge', source: :pledges

  delegate :status, to: :cakester_request, allow_nil: true

  scope :regular, ->{ where(kind: :regular) }
  scope :exclusive, ->{ where(kind: :exclusive) }

  scope :with_campaign, ->{ eager_load(:campaign) }
  scope :active, ->{ where('campaigns.status != ? AND campaigns.end_date > ?', :past, Time.zone.now) }

  before_save do
    self.kind = self.cakester_request_id.nil? ? :regular : :exclusive
  end

  def regular?
    self.kind == 'regular'
  end

  def exclusive?
    self.kind == 'exclusive'
  end
end
