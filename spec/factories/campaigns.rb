# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :campaign do
    title{ Faker::Lorem.sentence }
    launch_date{ Time.now + 2.months }
    end_date{ Time.now + 4.months }
    cause { Faker::Lorem.sentence }
    headline { Faker::Lorem.sentence }
    story { Faker::Lorem.paragraph }
    fundraiser

    before(:create) do |campaign|
      campaign.sponsor_categories = build_list(:sponsor_category, 3, campaign: campaign)
    end
  end
end
