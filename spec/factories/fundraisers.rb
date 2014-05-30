# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fundraiser do
    causes { Fundraiser::CAUSES.sample(5) }
    min_pledge{ Fundraiser::MIN_PLEDGES.sample }
    min_click_donation{ Fundraiser::MIN_CLICK_DONATIONS.sample }
    manager_name{ Faker::Name.name }
    manager_title{ Faker::Name.title }
    manager_email{ Faker::Internet.safe_email }
    manager_phone{ Faker::PhoneNumber.phone_number }
    name { Faker::Lorem.sentence }
    mission { Faker::Lorem.paragraph }
    supporter_demographics { Faker::Lorem.paragraph }
    phone { Faker::PhoneNumber.phone_number }
    website { Faker::Internet.domain_name }
    email { Faker::Internet.safe_email }
    association :manager, factory: :fundraiser_user
    location
    stripe_account

    after(:create) do |fr|
      fr.manager.set_fundraiser(fr)
    end

    factory :fundraiser_without_stripe_account do
      after(:create) do |fr|
        fr.stripe_account.destroy
      end
    end

    factory :fundraiser_with_stripe_account do
      association :stripe_account, factory: :fundraiser_stripe_account
    end
  end
end
