# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :pledge do
    name { Faker::Lorem.sentence }
    mission { Faker::Lorem.sentence }
    headline { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    amount_per_click "9.00"
    total_amount "99.00"
    website_url { "http://#{Faker::Internet.domain_name}" }
    clicks_count 1
    bonus_clicks_count 1
    status :accepted
    campaign
    sponsor
    picture

    factory :not_clicked_pledge do
      clicks_count 0
      bonus_clicks_count 0
    end

    factory :pending_pledge do
      status :pending
    end

    factory :rejected_pledge do
      status :rejected
    end

    factory :past_pledge do
      association :campaign, factory: :past_campaign
      status :past
    end

    factory :pledge_with_levels do
      association :campaign, factory: :campaign_with_pledge_levels
    end
  end
end
