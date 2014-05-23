module FactoryHelpers
  extend self

  def stripe_card_token(key)
    WebMock.disable!
    token = Stripe::Token.create(
      {
        card: {
        :number => "4242424242424242",
        :exp_month => 5,
        :exp_year => 2015,
        :cvc => "314"
        }
      }, 
      key
    )
    token.id
  end
end