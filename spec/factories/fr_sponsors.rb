# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fr_sponsor do
    name { Faker::Lorem.sentence }
    email { Faker::Internet.safe_email }
    website_url { "http://#{Faker::Internet.domain_name}" }
    fundraiser
  end
end
