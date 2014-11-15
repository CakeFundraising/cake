# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quick_pledge do
    name "MyString"
    donation_per_click ""
    total_amount ""
    website_url "MyString"
    campaign_id 1
    sponsorable_id 1
    sponsorable_type "MyString"
  end
end
