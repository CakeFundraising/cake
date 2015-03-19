class Browser < ActiveRecord::Base
  belongs_to :user

  has_many :clicks, -> { where(bonus: false) }, class_name: 'Click', dependent: :destroy
  has_many :bonus_clicks, -> { where(bonus: true) }, class_name: 'Click', dependent: :destroy

  has_many :extra_clicks, -> { where(bonus: false) }, class_name: 'ExtraClick', dependent: :destroy
  has_many :bonus_extra_clicks, -> { where(bonus: true) }, class_name: 'ExtraClick', dependent: :destroy

  scope :with_fingerprint, ->(fingerprint){ where(fingerprint: fingerprint) }
  scope :with_token, ->(token){ where(token: token) }

  scope :equal_to, ->(other){ where(fingerprint: other.fingerprint, token: other.token) }

  validates :token, :fingerprint, presence: true
end
