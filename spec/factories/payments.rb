# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    total_cents { rand(99999) }
    association :item, factory: :invoice
    association :payer, factory: :sponsor
    association :recipient, factory: :fundraiser_with_stripe_account
    kind 'invoice_payment'
    card_token { FactoryHelpers.stripe_card_token(Rails.configuration.stripe[:publishable_key]) }

    factory :payment_with_cakester do
      association :item, factory: :invoice_with_cakester
    end
  end
end
