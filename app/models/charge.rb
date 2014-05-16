class Charge < ActiveRecord::Base
  belongs_to :chargeable, polymorphic: true

  monetize :amount_cents
  monetize :total_fee_cents

  def resource
    Stripe::Charge.retrieve(self.stripe_id)
  end

  def balance_transaction
    Stripe::BalanceTransaction.retrieve(self.balance_transaction_id)
  end
end
