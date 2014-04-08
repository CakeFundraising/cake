class SponsorCategory < ActiveRecord::Base
  belongs_to :campaign

  monetize :min_value_cents, numericality: { greater_than: 0 }
  monetize :max_value_cents, numericality: { greater_than: 0 }
end
