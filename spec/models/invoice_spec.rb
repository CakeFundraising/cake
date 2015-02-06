require 'rails_helper'

describe Invoice do
  it { should belong_to(:pledge) }
  it { should have_one(:campaign).through(:pledge) }
  it { should have_one(:fundraiser).through(:campaign) }
  it { should have_one(:sponsor).through(:pledge) }

  it { should have_one(:payment) }

  it "should monetize the due field" do
    invoice = FactoryGirl.create(:invoice)
    expect(invoice).to monetize(:due_cents)
  end

  it "should monetize the click_donation field" do
    invoice = FactoryGirl.create(:invoice)
    expect(invoice).to monetize(:click_donation_cents)
  end

  it "should have statuses" do
    expect(Invoice.statuses[:status]).to eq [:due_to_pay, :paid]
  end
end
