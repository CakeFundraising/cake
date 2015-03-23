module Fees
  extend ActiveSupport::Concern

  module ClassMethods
    protected

    def calculate_fees(amount)
      ((amount*(Cake::APPLICATION_FEE + Cake::STRIPE_FEE)) + 30).round
    end

    def net_amount(amount)
      amount - self.calculate_fees(amount)
    end
  end
end