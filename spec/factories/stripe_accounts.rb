# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stripe_account do
    uid { SecureRandom.hex(8) }
    stripe_publishable_key "pk_test_4TC9mWqNIII00qjeayaxMvDF"
    token "sk_test_4TC9E7MBIdJTRUkMPzmmm82j"

    factory :sponsor_stripe_account do
      association :account, factory: :sponsor
      
      after(:create) do |sa|
        sa.create_stripe_customer( CreditCard.new(token: FactoryHelpers.stripe_card_token(Rails.configuration.stripe[:publishable_key])) )
      end
    end

    factory :fundraiser_stripe_account do
      association :account, factory: :fundraiser
      
      after(:create) do |sa|
        sa.create_stripe_recipient(FactoryGirl.build(:bank_account) )
      end
    end
  end
end
