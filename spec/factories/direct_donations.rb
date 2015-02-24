# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :direct_donation do
    email { Faker::Internet.safe_email }
    amount_cents { rand(99999) }
    card_token { FactoryHelpers.stripe_card_token(fundraiser.stripe_account.token) }
    fundraiser
  end
end
