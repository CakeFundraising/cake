# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :click do
    request_ip { Faker::Internet.ip_v4_address }
    email { Faker::Internet.email }
    pledge
  end
end
