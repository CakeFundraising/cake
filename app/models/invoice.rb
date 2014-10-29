class Invoice < ActiveRecord::Base
  include Statusable

  has_statuses :due_to_pay, :paid

  MIN_DUE = 0.5

  belongs_to :pledge, touch: true
  has_one :campaign, through: :pledge
  has_one :fundraiser, through: :campaign
  has_one :sponsor, through: :pledge

  has_one :payment, as: :item
  has_many :charges, through: :payment

  monetize :click_donation_cents
  monetize :due_cents

  scope :outstanding, ->{ where.not(status: :paid) }
  scope :latest, ->{ order(created_at: :desc) }

  def fees
    self.charges.sum(&:total_fee_cents).to_i
  end

  def estimated_fees
    (self.due_cents*(Cake::APPLICATION_FEE + Cake::STRIPE_FEE)) + 30
  end

  def estimated_net_donation
    self.due_cents - estimated_fees
  end
end
