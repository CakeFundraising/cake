# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :pledge do
    mission { Faker::Lorem.sentence }
    headline { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    amount_per_click "9.00"
    total_amount "99.00"
    website_url { Faker::Internet.domain_name }
    status :accepted
    campaign
    sponsor
    picture

    factory :pending_pledge do
      status :pending
    end

    factory :rejected_pledge do
      status :rejected
    end

    factory :past_pledge do
      association :campaign, factory: :past_campaign
    end

    factory :pledge_with_levels do
      association :campaign, factory: :campaign_with_pledge_levels
    end
  end
end
