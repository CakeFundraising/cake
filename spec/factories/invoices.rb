# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    clicks { rand(9999999) }
    click_donation_cents { rand(999) }
    due_cents { clicks*click_donation_cents }
    pledge
  end
end
