# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bank_account do
    name{ Faker::Name.name }
    type "individual"
    email{ Faker::Internet.safe_email }
    tax_id "000000000"
    token{ FactoryHelpers.stripe_bank_account_token }
  end
end