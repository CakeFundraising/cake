# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sweepstake do
    title { Faker::Lorem.sentence }
    winners_quantity { rand(99) }
    claim_prize_instructions { Faker::Lorem.paragraph }
    description { Faker::Lorem.paragraph }
    avatar { Rack::Test::UploadedFile.new(File.join(Rails.root, "db/seeds/support/images/coupon.jpg")) }
    pledge
  end
end
