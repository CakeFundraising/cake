# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quick_pledge, class: QuickPledge, parent: :pledge do
    type 'QuickPledge'
    association :campaign, factory: :regular_campaign
  end
end
