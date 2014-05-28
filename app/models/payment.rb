class Payment < ActiveRecord::Base
  attr_accessor :card_token, :customer_id

  belongs_to :item, polymorphic: true
  belongs_to :payer, polymorphic: true
  belongs_to :recipient, polymorphic: true

  has_many :charges, as: :chargeable

  monetize :total_cents

  validates :total, :kind, :item, :payer, :recipient, presence: true

  before_save :stripe_charge_card

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

  private

  def stripe_charge_card
    charge = Stripe::Charge.create(
      amount: self.total_cents,
      currency: self.total_currency.downcase,
      card: self.card_token,
      customer: self.customer_id,
      description: "#{item_type} ##{item_id} Payment"
    )
    store_transaction(charge) 
  end

  def store_transaction(stripe_charge) 
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
end
