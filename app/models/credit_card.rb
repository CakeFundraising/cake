class CreditCard
  include ActiveModel::Model
  attr_accessor :number, :cvc, :exp_month, :exp_year, :token

  validates :token, presence: true    
end