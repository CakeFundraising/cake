class Payment < ActiveRecord::Base
  include Statusable
  include PaymentsHelper
  has_statuses :charged, :transferred

  attr_accessor :card_token, :customer_id

  belongs_to :item, polymorphic: true
  belongs_to :payer, polymorphic: true
  belongs_to :recipient, polymorphic: true

  has_many :charges, as: :chargeable
  has_many :transfers, as: :transferable

  monetize :total_cents

  validates :total, :kind, :item, :payer, :recipient, presence: true

  delegate :has_cakester?, to: :item

  before_create :stripe_charge_card
  after_create :set_as_paid

  def self.new_invoice(params, payer)
    payment = new(params)
    payment.item_type = 'Invoice'        
    payment.kind = 'invoice_payment'
    payment.recipient = payment.item.fundraiser
    payment.payer = payer
    payment.total_cents = payment.item.due_cents
    payment.customer_id = payer.stripe_account.stripe_customer_id if payer.stripe_account.present?
    payment
  end

  def self.new_quick_invoice(params, payer)
    payment = new(params)
    payment.item_type = 'Invoice'        
    payment.kind = 'invoice_payment'
    payment.recipient = AdminUser.first
    payment.payer = payer
    payment.total_cents = payment.item.total_fees_cents
    payment
  end

  def transfer!
    if recipient_stripe_account? and balance_available?
      stripe_transfer
      notify_transfer
      update_attribute(:status, :transferred)
    end
  end

  def notify_regular_charge
    item.fundraiser.users.each do |user|
      InvoiceNotification.payment_charge(item.id, user.id).deliver
    end
  end

  def notify_quick_invoice_charge
    item.fundraiser.users.each do |user|
      InvoiceNotification.quick_payment_charge(item.id, user.id).deliver
    end
  end

  private

  def set_as_paid
    item.update_attribute(:status, :paid) #set invoice as paid
  end

  def notify_transfer
    self.recipient.users.each do |user|
      InvoiceNotification.payment_transfer(item.id, user.id).deliver
    end
  end
end
