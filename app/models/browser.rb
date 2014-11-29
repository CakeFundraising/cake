class Browser < ActiveRecord::Base
  belongs_to :user

  validates :token, presence: true

  scope :with_fingerprint, ->(fingerprint){ where(fingerprint: fingerprint) }
end
