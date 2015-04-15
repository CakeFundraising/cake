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
    if present_recipient? and balance_available?
      stripe_transfer
      notify_transfer
      update_attribute(:status, :transferred)
    end
  end

  def notify_normal_charge
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

  #Charges
  def stripe_charge_card
    charge = Stripe::Charge.create(
      amount: self.total_cents,
      currency: self.total_currency.downcase,
      card: self.card_token,
      customer: self.customer_id,
      description: "CakeCauseMarketing.com #{item_type} ##{item_id} Payment"
    )
    store_charge(charge) 
  end

  def store_charge(stripe_charge) 
    balance_transaction = Stripe::BalanceTransaction.retrieve(stripe_charge.balance_transaction)

    self.charges.build(
      stripe_id: stripe_charge.id,
      balance_transaction_id: stripe_charge.balance_transaction,
      kind: stripe_charge.object,
      amount_cents: stripe_charge.amount,
      amount_currency: stripe_charge.currency.upcase,
      total_fee_cents: balance_transaction.fee,
      paid: stripe_charge.paid,
      captured: stripe_charge.captured,
      fee_details: balance_transaction.fee_details.map(&:to_hash)
    )
  end

  def set_as_paid
    item.update_attribute(:status, :paid) #set invoice as paid
  end

  #Transfers
  def transfer_amount
    amount_with_stripe_fees = (((1-Cake::STRIPE_FEE)*self.total_cents) - 30).round
    (amount_with_stripe_fees*(1-Cake::APPLICATION_FEE)).round
  end

  def present_recipient?
    self.recipient.stripe_account.present? and self.recipient.stripe_account.stripe_recipient_id.present?
  end

  def balance_available?

    balance = self.get_stripe_balance

    available_amount = balance.available.first.amount
    available_amount > transfer_amount
  end

  def stripe_transfer
    transfer = Stripe::Transfer.create(
      amount: transfer_amount,
      currency: self.total_currency.downcase,
      recipient: self.recipient.stripe_account.stripe_recipient_id,
      statement_description: "CakeCauseMarketing.com Invoice #{item.id} Payment"
    )
    store_transfer(transfer)
  end

  def store_transfer(stripe_transfer)
    balance_transaction = Stripe::BalanceTransaction.retrieve(stripe_transfer.balance_transaction)

    self.transfers.build(
      stripe_id: stripe_transfer.id,
      balance_transaction_id: stripe_transfer.balance_transaction,
      kind: stripe_transfer.object,
      amount_cents: stripe_transfer.amount,
      amount_currency: stripe_transfer.currency.upcase,
      total_fee_cents: balance_transaction.fee + Cake::APPLICATION_FEE*stripe_transfer.amount,
      status: stripe_transfer.status
    ).save
  end

  def notify_transfer
    self.recipient.users.each do |user|
      InvoiceNotification.payment_transfer(item.id, user.id).deliver
    end
  end
end
