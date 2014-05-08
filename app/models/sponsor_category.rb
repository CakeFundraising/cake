class SponsorCategory < ActiveRecord::Base
  belongs_to :campaign

  monetize :min_value_cents
  monetize :max_value_cents

  validates :max_value, numericality: { greater_than: 0 }
  validates :min_value, numericality: { greater_than: 0 }

  validates :name, presence: true

  def self.levels
    map(&:name)
  end
end
