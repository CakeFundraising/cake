class SponsorCategory < ActiveRecord::Base
  belongs_to :campaign

  LENGTH = 3

  monetize :min_value_cents
  monetize :max_value_cents

  validates :max_value, numericality: { greater_than: 0 }, if: :persisted?
  validates :min_value, numericality: { greater_than: 0 }, if: :persisted?
  validates :name, presence: true
end
