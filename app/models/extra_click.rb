class ExtraClick < ActiveRecord::Base

  belongs_to :clickable, polymorphic: true, touch: true
  belongs_to :browser

  # counter_culture :clickable, column_name: Proc.new {|click| click.bonus ? 'bonus_clicks_count' : 'clicks_count' },
  #                 column_names: {
  #                     ["clicks.bonus = ?", true] => 'bonus_clicks_count',
  #                     ["clicks.bonus = ?", false] => 'clicks_count'
  #                 }

  validates :browser_id, :clickable_id, :clickable_type, presence: true

  scope :with_browser, ->{ eager_load(:browser) }

  scope :token, ->(token){ where('browsers.token = ?', token) }
  scope :fingerprint, ->(fingerprint){ where('browsers.fingerprint = ?', fingerprint) }

  scope :bonus, -> { where(bonus: true) }
  scope :unique, -> { where(bonus: false) }

end