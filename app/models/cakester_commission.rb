class CakesterCommission < ActiveRecord::Base
  belongs_to :commissionable, polymorphic: true

  validates :deal_type, :deal_value, presence: true

  DEAL_TYPES = %w{probono flat percentage}

  DEAL_VALUES = (5..50).step(5).to_a
end
