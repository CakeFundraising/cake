class Payment < ActiveRecord::Base
  include Statusable
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
  after_create :set_as_paid, :notify_charge

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

  def transfer!
    stripe_trasfer
    notify_transfer
    update_attribute(:status, :transferred)
  end

  private

  #Charges
  def stripe_charge_card
    charge = Stripe::Charge.create(
      amount: self.total_cents,
      currency: self.total_currency.downcase,
      card: self.card_token,
      customer: self.customer_id,
      description: "#{item_type} ##{item_id} Payment"
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

  def notify_charge
    item.fundraiser.users.each do |user|
      InvoiceNotification.payment_charge(item, user).deliver
    end
  end

  #Transfers
  def stripe_trasfer
    amount = ((1-CakeConstants::APPLICATION_FEE)*self.total_cents).round

    transfer = Stripe::Transfer.create(
      amount: amount,
      currency: self.total_currency.downcase,
      recipient: self.recipient.stripe_account.stripe_recipient_id,
      statement_description: "Cake Invoice #{item.id} Payment Transfer"
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
      total_fee_cents: balance_transaction.fee + CakeConstants::APPLICATION_FEE*stripe_transfer.amount,
      status: stripe_transfer.status
    ).save
  end

  def notify_transfer
  end
end
