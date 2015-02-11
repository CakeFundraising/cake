FactoryGirl.define do
  factory :subscriptor do
    first_name { Faker::Lorem.sentence }
    last_name { Faker::Lorem.sentence }
    email { Faker::Internet.safe_email }
    association :object, factory: :fundraiser
  end
end
