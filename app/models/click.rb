class Click < ActiveRecord::Base
  belongs_to :pledge, touch: true
  belongs_to :browser

  counter_culture :pledge, column_name: Proc.new {|click| click.bonus ? 'bonus_clicks_count' : 'clicks_count' },
  column_names: {
    ["clicks.bonus = ?", true] => 'bonus_clicks_count',
    ["clicks.bonus = ?", false] => 'clicks_count'
  }

  validates :browser_id, :pledge_id, presence: true

  scope :with_browser, ->{ eager_load(:browser) }

  scope :token, ->(token){ where('browsers.token = ?', token) }
  scope :fingerprint, ->(fingerprint){ where('browsers.fingerprint = ?', fingerprint) }

  scope :bonus, -> { where(bonus: true) }
  scope :unique, -> { where(bonus: false) }

  def pusherize
    unless self.bonus #Unique clicks only
      campaign = self.pledge.campaign

      Pusher.trigger("campaign_#{campaign.id}_raised", 'update', {
        raised: campaign.decorate.raised,
        campaign_thermometer: campaign.pledges_thermometer,
        pledge_id: self.pledge_id,
        pledge_thermometer: self.pledge.reload.thermometer
      })
    end
  end

end
