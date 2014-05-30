class Transfer < ActiveRecord::Base
  belongs_to :transferable, polymorphic: true

  monetize :amount_cents
  monetize :total_fee_cents

  def resource
    Stripe::Transfer.retrieve(self.stripe_id)
  end

  def balance_transaction
    Stripe::BalanceTransaction.retrieve(self.balance_transaction_id)
  end
end
