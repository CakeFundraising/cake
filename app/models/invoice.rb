class Invoice < ActiveRecord::Base
  include Statusable

  has_statuses :due_to_pay, :paid, :in_arbitration

  belongs_to :pledge
  has_one :campaign, through: :pledge
  has_one :fundraiser, through: :campaign
  has_one :sponsor, through: :pledge

  has_one :payment, as: :item

  monetize :click_donation_cents
  monetize :due_cents

  scope :outstanding, ->{ where.not(status: :paid) }
end
