# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :impression do
    view "campaign/show"
    association :impressionable, factory: :campaign
    browser

    factory :pledge_impression do
      association :impressionable, factory: :pledge
      view "pledge/show"
    end
  end
end
