# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :campaign do
    title { Faker::Lorem.sentence }
    launch_date { Time.now - 2.weeks }
    end_date { Time.now + 4.months }
    causes { Campaign::CAUSES.sample(5) }
    scopes { Campaign::SCOPES.sample(2) }
    headline { Faker::Lorem.sentence }
    story { Faker::Lorem.paragraph }
    mission { Faker::Lorem.paragraph }
    custom_pledge_levels true
    fundraiser
    status :live

    factory :campaign_with_pledge_levels do
      before(:create) do |campaign|
        campaign.sponsor_categories = build_list(:sponsor_category, 3, campaign: campaign)
      end
    end

    factory :inactive_campaign do
      status :inactive
    end

    factory :past_campaign do
      launch_date { Time.now - 4.months }
      end_date { Time.now - 2.months }
    end
  end
end
