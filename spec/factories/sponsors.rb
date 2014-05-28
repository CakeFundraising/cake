# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sponsor do
    mission { Faker::Lorem.paragraph }
    customer_demographics { Faker::Lorem.paragraph }
    manager_name{ Faker::Name.name }
    manager_title{ Faker::Name.title }
    manager_email{ Faker::Internet.safe_email }
    manager_phone{ Faker::PhoneNumber.phone_number }
    name { Faker::Lorem.sentence }
    phone { Faker::PhoneNumber.phone_number }
    website { Faker::Internet.domain_name }
    email { Faker::Internet.safe_email }
    cause_requirements { [Sponsor::CAUSE_REQUIREMENTS.sample] }
    scopes { Sponsor::SCOPES.sample(2) }
    causes { Sponsor::CAUSES.sample(3) }
    association :manager, factory: :sponsor_user
    location
    stripe_account

    after(:create) do |sponsor|
      sponsor.manager.set_sponsor(sponsor)
    end

    factory :sponsor_without_stripe_account do
      after(:create) do |sp|
        sp.stripe_account.destroy
      end
    end
  end
end
