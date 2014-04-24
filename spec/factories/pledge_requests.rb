# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pledge_request do
    sponsor
    fundraiser
    campaign
  end
end
