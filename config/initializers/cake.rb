module Cake
  APPLICATION_FEE = 0.050
  STRIPE_FEE = 0.029

  def self.global_raised
    Invoice.paid.sum(:due_cents).to_i/100
  end
end