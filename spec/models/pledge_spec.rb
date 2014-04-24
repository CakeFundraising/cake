require 'spec_helper'

describe Pledge do
  it { should validate_presence_of(:donation_type) }
  it { should validate_presence_of(:campaign) }
  it { should validate_presence_of(:website_url) }
  
  # it { should validate_numericality_of(:amount_per_click).with_message("must be an integer").is_greater_than(0).is_less_than_or_equal_to(1000) }
  # it { should validate_numericality_of(:total_amount).with_message("must be an integer").is_greater_than(0) }

  it "should validate other attributes when editing" do
    subject.stub(:persisted?) { true } 
    should validate_presence_of(:mission) 
    should validate_presence_of(:headline) 
    should validate_presence_of(:description) 
  end

  it { should belong_to(:sponsor) }
  it { should belong_to(:campaign) }
  it { should have_one(:fundraiser).through(:campaign) }
  it { should have_one(:picture).dependent(:destroy) }
  it { should have_one(:video).dependent(:destroy) }
  it { should have_many(:coupons).dependent(:destroy) }
  it { should have_many(:sweepstakes).dependent(:destroy) }

  it { should accept_nested_attributes_for(:picture).update_only(true) }
  it { should accept_nested_attributes_for(:video).update_only(true) }
  it { should accept_nested_attributes_for(:coupons) }
  it { should accept_nested_attributes_for(:sweepstakes) }

  it "should build a picture if new object" do
    new_pledge = FactoryGirl.build(:pledge)
    new_pledge.picture.should_not be_nil
    new_pledge.picture.should be_instance_of(Picture)
  end

  it "should be return a collection of past pledges" do
    pending "Pledge.past is not defined yet..\n Used in sponsor dashboard controller history action"
  end

  it "should have statuses" do
    Pledge.statuses[:status].should == [:pending, :active, :rejected]
  end
end