# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :browser do
    token { SecureRandom.uuid.to_s }
    fingerprint { SecureRandom.random_number(10000000000).to_s }

    factory :user_browser do
      user
    end
  end
end
