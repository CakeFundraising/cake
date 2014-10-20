class Invoice < ActiveRecord::Base
  include Statusable

  has_statuses :due_to_pay, :paid

  MIN_DUE = 0.5

  belongs_to :pledge
  has_one :campaign, through: :pledge
  has_one :fundraiser, through: :campaign
  has_one :sponsor, through: :pledge

  has_one :payment, as: :item

  monetize :click_donation_cents
  monetize :due_cents

  scope :outstanding, ->{ where.not(status: :paid) }
  scope :latest, ->{ order(created_at: :desc) }
end
