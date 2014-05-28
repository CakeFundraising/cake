# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stripe_account do
    uid { SecureRandom.hex(8) }
    stripe_publishable_key "pk_test_av3DexUAm41o6QL2yJOoJLLd"
    token "sk_test_gipO7Xq9sytJOy2bmlfmtVob"

    factory :sponsor_stripe_account do
      association :account, factory: :sponsor
      
      after(:create) do |sa|
        sa.create_stripe_customer( CreditCard.new(token: FactoryHelpers.stripe_card_token(Rails.configuration.stripe[:publishable_key])) )
      end
    end
  end
end
