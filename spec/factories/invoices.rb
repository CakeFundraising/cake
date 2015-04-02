# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    association :pledge, factory: :past_pledge

    clicks { rand(999) }
    click_donation_cents { rand(999) }
    due_cents { clicks*click_donation_cents }
    fees_cents { Invoice.send(:calculate_fees, due_cents) }
    net_amount_cents { Invoice.fr_net_amount(pledge) }
    status :paid

    factory :invoice_with_cakester do
      cakester_rate { pledge.cakester_rate }
      cakester_commission_cents { Invoice.calculate_cakester_commission(pledge) }
    end

    factory :pending_invoice do
      status :due_to_pay
    end
  end
end
