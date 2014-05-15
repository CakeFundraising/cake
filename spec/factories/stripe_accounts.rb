# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :stripe_account do
    uid "MyString"
    stripe_publishable_key "MyString"
    token "MyString"
    fundraiser_id 1
  end
end
