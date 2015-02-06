require 'rails_helper'

describe Charge do
  it { should belong_to(:chargeable) }

  it "should monetize the amount field" do
    charge = FactoryGirl.create(:charge)
    expect(charge).to monetize(:amount_cents)
  end

  it "should monetize the total_fee field" do
    charge = FactoryGirl.create(:charge)
    expect(charge).to monetize(:total_fee_cents)
  end
end
