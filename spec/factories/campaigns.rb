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
    custom_pledge_levels false
    fundraiser
    status :live

    factory :campaign_with_pledge_levels do
      custom_pledge_levels true
      before(:create) do |campaign|
        campaign.sponsor_categories << create(:sponsor_category, campaign: campaign, min_value_cents: 10000, max_value_cents: 100000)
        campaign.sponsor_categories << create(:sponsor_category, campaign: campaign, min_value_cents: 100001, max_value_cents: 200000)
        campaign.sponsor_categories << create(:sponsor_category, campaign: campaign, min_value_cents: 200001, max_value_cents: 300000)
      end
    end

    factory :inactive_campaign do
      status :inactive
    end

    factory :past_campaign do
      status :past
      launch_date { Time.now - 4.months }
      end_date { Time.now - 2.months }
    end
  end
end
