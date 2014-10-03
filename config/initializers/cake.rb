module Cake
  APPLICATION_FEE = 0.05

  def self.global_raised
    Invoice.paid.sum(:due_cents).to_i/100
  end
end