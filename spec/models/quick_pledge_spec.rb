require 'spec_helper'

describe QuickPledge do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:campaign) }
  it { should validate_presence_of(:website_url) }

  it { should belong_to(:sponsor) }
  it { should belong_to(:campaign) }
  it { should have_one(:fundraiser).through(:campaign) }
  it { should have_one(:picture).dependent(:destroy) }

  it { should accept_nested_attributes_for(:picture).update_only(true) }

  it "should build a picture if new object" do
    new_pledge = FactoryGirl.build(:quick_pledge)
    new_pledge.picture.should_not be_nil
    new_pledge.picture.should be_instance_of(Picture)
  end

  it "should have statuses" do
    QuickPledge.statuses[:status].should == [:incomplete, :pending, :accepted, :rejected, :past]
  end
end
