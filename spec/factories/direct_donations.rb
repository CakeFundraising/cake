# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :direct_donation do
    email { Faker::Internet.safe_email }
    card_token { FactoryHelpers.stripe_card_token }
    amount_cents { rand(99999) }
    campaign
  end
end
