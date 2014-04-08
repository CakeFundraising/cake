# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sponsor_category do
    name { Faker::Lorem.sentence }
    min_value_cents { rand(99999) }
    max_value_cents { rand(99999) }
  end
end
