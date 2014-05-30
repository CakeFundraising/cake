require 'spec_helper'

describe Invoice do
  it { should belong_to(:pledge) }
  it { should have_one(:campaign).through(:pledge) }
  it { should have_one(:fundraiser).through(:campaign) }
  it { should have_one(:sponsor).through(:pledge) }

  it { should have_one(:payment) }

  it "should monetize the due field" do 
    monetize(:due_cents).should be_true
  end

  it "should monetize the click_donation field" do 
    monetize(:click_donation_cents).should be_true
  end

  it "should have statuses" do
    Invoice.statuses[:status].should == [:due_to_pay, :paid, :in_arbitration]
  end
end
