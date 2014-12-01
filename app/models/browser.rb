class Browser < ActiveRecord::Base
  belongs_to :user

  validates :token, :fingerprint, presence: true

  scope :with_fingerprint, ->(fingerprint){ where(fingerprint: fingerprint) }
  scope :with_token, ->(token){ where(token: token) }

  scope :equal_to, ->(other){ where(fingerprint: other.fingerprint, token: other.token) }
end
