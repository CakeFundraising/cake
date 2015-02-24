class DirectDonation < ActiveRecord::Base
  belongs_to :fundraiser
  has_one :charge, as: :chargeable

  monetize :amount_cents

  validates :fundraiser, :card_token, :amount, :email, presence: true

  before_create :stripe_charge_card

  private

  def stripe_charge_card
    charge = Stripe::Charge.create({
      amount: self.amount_cents,
      currency: self.amount_currency.downcase,
      card: self.card_token,
      description: "Direct Donation from #{self.email}",
      application_fee: (self.amount_cents*Cake::APPLICATION_FEE).round # amount in cents
      },
      self.fundraiser.stripe_account.token # user's access token from the Stripe Connect flow
    )
    store_transaction(charge) 
  end

  def store_transaction(stripe_transaction) 
    balance_transaction = Stripe::BalanceTransaction.retrieve(stripe_transaction.balance_transaction, self.fundraiser.stripe_account.token)

    self.build_charge(
      stripe_id: stripe_transaction.id,
      balance_transaction_id: stripe_transaction.balance_transaction,
      kind: stripe_transaction.object,
      amount_cents: stripe_transaction.amount,
      amount_currency: stripe_transaction.currency.upcase,
      total_fee_cents: balance_transaction.fee,
      paid: stripe_transaction.paid,
      captured: stripe_transaction.captured,
      fee_details: balance_transaction.fee_details.map(&:to_hash)
    ).save
  end
end
