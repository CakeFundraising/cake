class CakesterCommission < ActiveRecord::Base
  belongs_to :commissionable, polymorphic: true

  validates :deal_type, presence: true
  validates :percentage_value, presence: true, if: ->(cc){ cc.deal_type == 'Percentage' }
  validates :flat_value, presence: true, if: ->(cc){ cc.deal_type == 'Flat' }

  DEAL_TYPES = %w{probono flat percentage}

  DEAL_VALUES = (5..50).step(5).to_a
end
