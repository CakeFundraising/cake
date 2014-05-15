# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :direct_donation do
    email "MyString"
    card_token "MyString"
    campaign_id 1
  end
end
