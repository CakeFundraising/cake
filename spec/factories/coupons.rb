# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :coupon do
    title { Faker::Lorem.sentence }
    expires_at { Time.now + 3.months }
    promo_code { rand(9999) }
    description { Faker::Lorem.paragraph }
    merchandise_categories { Coupon::CATEGORIES.sample(3) }
    extra_donation_pledge false
    pledge
    picture

    factory :extra_donation_pledge do
      extra_donation_pledge true
      unit_donation{ rand(99) + 1  }
      total_donation{ rand(99999) + 1 }
    end
  end
end
