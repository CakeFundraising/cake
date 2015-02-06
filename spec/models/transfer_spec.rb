require 'rails_helper'

describe Transfer do
  it { should belong_to(:transferable) }

  it "should monetize the amount field" do
    transfer = FactoryGirl.build(:transfer)
    expect(transfer).to monetize(:amount_cents)
  end

  it "should monetize the total_fee field" do
    transfer = FactoryGirl.build(:transfer)
    expect(transfer).to monetize(:total_fee_cents)
  end
end
