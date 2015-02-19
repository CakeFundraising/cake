FactoryGirl.define do
  factory :cakester do
    name { Faker::Lorem.sentence }
    email { Faker::Internet.safe_email }
    phone { Faker::PhoneNumber.phone_number }
    website { Faker::Internet.url }
    manager_name { Faker::Lorem.sentence }
    manager_email { Faker::Internet.safe_email }
    manager_title "Mr"
    manager_phone { Faker::PhoneNumber.phone_number }
    mission { Faker::Lorem.paragraph }
    about { Faker::Lorem.paragraph }
    cause_requirements { [Cakester::CAUSE_REQUIREMENTS.sample] }
    scopes { Cakester::SCOPES.sample(2) }
    causes { Cakester::CAUSES.sample(3) }
    email_subscribers { Cakester::SUBSCRIBER_RANGES.sample }
    facebook_subscribers { Cakester::SUBSCRIBER_RANGES.sample }
    twitter_subscribers { Cakester::SUBSCRIBER_RANGES.sample }
    pinterest_subscribers { Cakester::SUBSCRIBER_RANGES.sample }
    location
    picture
  end

end
