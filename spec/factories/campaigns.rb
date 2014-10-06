# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :campaign do
    title { Faker::Lorem.sentence }
    launch_date { Time.now - 2.weeks }
    end_date { Time.now + 4.months }
    goal {rand(999) + 1 }
    causes { Campaign::CAUSES.sample(5) }
    main_cause { Campaign::CAUSES.sample }
    scopes { Campaign::SCOPES.sample(2) }
    headline { Faker::Lorem.sentence }
    story { Faker::Lorem.paragraph }
    mission { Faker::Lorem.paragraph }
    custom_pledge_levels false
    fundraiser
    status :launched

    factory :campaign_with_pledge_levels do
      custom_pledge_levels true
      after(:create) do |campaign|
        campaign.sponsor_categories << create(:sponsor_category, name: 'Highest Sponsor', campaign: campaign, min_value_cents: 20100, max_value_cents: 100000)
        campaign.sponsor_categories << create(:sponsor_category, name: 'Medium Sponsor' , campaign: campaign, min_value_cents: 10100, max_value_cents: 20000)
        campaign.sponsor_categories << create(:sponsor_category, name: 'Lowest Sponsor' , campaign: campaign, min_value_cents: 5000, max_value_cents: 10000)
      end
    end

    factory :uncompleted_campaign do
      status :uncompleted
    end

    factory :pending_campaign do
      status :pending
    end

    factory :past_campaign do
      status :past
      launch_date { Time.now - 4.months }
      end_date { Time.now - 2.months }
    end
  end
end
