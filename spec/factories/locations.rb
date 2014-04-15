# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :location do
    address{ Faker::Address.street_address }
    country_code 'US'
    state_code{ Faker::Address.state_abbr }
    zip_code { Faker::Address.zip_code }
    city { Faker::Address.city }
    name { Faker::Lorem.sentence }
  end
end
