# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    total_cents { rand(99999) }
    association :item, factory: :invoice
    association :payer, factory: :sponsor
    association :recipient, factory: :fundraiser
    kind 'invoice_payment'
    card_token { FactoryHelpers.stripe_card_token(Rails.configuration.stripe[:publishable_key]) }
  end
end
