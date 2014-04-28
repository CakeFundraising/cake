# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :pledge do
    mission { Faker::Lorem.sentence }
    headline { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    amount_per_click "9.00"
    donation_type { Pledge::DONATION_TYPES.sample }
    total_amount "99999.00"
    website_url { Faker::Internet.domain_name }
    status :accepted
    campaign
    sponsor

    factory :pending_pledge do
      status :pending
    end

    factory :rejected_pledge do
      status :rejected
    end

    factory :past_pledge do
      association :campaign, factory: :past_campaign
    end
  end
end
