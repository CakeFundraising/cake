# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    clicks { rand(99999) }
    click_donation_cents { rand(999) }
    due_cents { clicks*click_donation_cents }
    association :pledge, factory: :past_pledge
    status :paid

    factory :pending_invoice do
      status :due_to_pay
    end
  end
end
