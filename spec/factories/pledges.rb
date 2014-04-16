# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pledge do
    mission "MyString"
    headline "MyString"
    description "MyText"
    amount_per_click ""
    donation_type "MyString"
    total_amount ""
    website_url "MyString"
    campaign_id 1
    sponsor_id 1
  end
end
