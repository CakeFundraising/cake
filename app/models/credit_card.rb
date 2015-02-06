class CreditCard
  include ActiveModel::Model
  attr_accessor :number, :cvc, :exp_month, :exp_year, :token

  validates :token, presence: true 

  def update(stripe_account)
    customer = stripe_account.customer
    stripe_card = customer.cards.create(card: self.token)
    customer.default_card = stripe_card.id
    customer.save
  end
end