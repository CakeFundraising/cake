# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quick_pledge do
    name { Faker::Lorem.sentence }
    amount_per_click "2.00"
    total_amount "4500.00"
    website_url { "http://#{Faker::Internet.domain_name}" }
    campaign
    picture
  end
end
