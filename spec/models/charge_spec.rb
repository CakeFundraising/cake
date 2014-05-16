require 'spec_helper'

describe Charge do
  it { should belong_to(:chargeable) }

  it "should monetize the amount field" do 
    monetize(:amount_cents).should be_true
  end

  it "should monetize the total_fee field" do 
    monetize(:total_fee_cents).should be_true
  end
end
