# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    title { Faker::Lorem.sentence }
    expires_at { Time.now + 3.months }
    promo_code { rand(9999) }
    description { Faker::Lorem.paragraph }
    remote_avatar_url { "http://placehold.it/500x500" }
    remote_qrcode_url { "http://placehold.it/500x500" }
    pledge
  end
end
