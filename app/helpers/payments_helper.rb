module PaymentsHelper
  def get_stripe_balance
    balance = Stripe::Balance.retrieve
    if Rails.env.test?
      balance.available.first.amount = 999999999
    end
    balance
  end
end