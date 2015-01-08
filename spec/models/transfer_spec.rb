require 'rails_helper'

describe Transfer do
  it { should belong_to(:transferable) }

  it "should monetize the amount field" do 
    monetize(:amount_cents).should be true
  end

  it "should monetize the total_fee field" do 
    monetize(:total_fee_cents).should be true
  end
end
