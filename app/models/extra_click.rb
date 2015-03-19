class ExtraClick < ActiveRecord::Base

  belongs_to :clickable, polymorphic: true, touch: true, counter_cache: true
  belongs_to :browser

  validates :browser_id, :clickable_id, :clickable_type, presence: true

  scope :with_browser, ->{ eager_load(:browser) }

  scope :token, ->(token){ where('browsers.token = ?', token) }
  scope :fingerprint, ->(fingerprint){ where('browsers.fingerprint = ?', fingerprint) }

end