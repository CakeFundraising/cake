# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    title { Faker::Lorem.sentence }
    expires_at { Time.now + 3.months }
    promo_code { rand(9999) }
    description { Faker::Lorem.paragraph }
    avatar { Rack::Test::UploadedFile.new(File.join(Rails.root, "db/seeds/support/images/coupon.jpg")) }
    qrcode { Rack::Test::UploadedFile.new(File.join(Rails.root, "db/seeds/support/images/qrcode.jpg")) }
    extra_donation_pledge false
    pledge

    factory :extra_donation_pledge do
      extra_donation_pledge true
      unit_donation{ rand(99) }
      total_donation{ rand(99999) }
    end
  end
end
