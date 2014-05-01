# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    full_name { Faker::Name.name }
    email { Faker::Internet.email }
    password 'password'

    factory :confirmed_user do
      confirmation_sent_at { Time.now }
      confirmed_at { Time.now }
      roles [:sponsor, :fundraiser]

      factory :sponsor_user do
        roles [:sponsor]
      end

      factory :fundraiser_user do
        roles [:fundraiser]
      end

      factory :social_connected_user do
        provider { User.omniauth_providers.sample }
        uid { SecureRandom.hex(8) }
        roles [:fundraiser]
      end
    end
  end
end
