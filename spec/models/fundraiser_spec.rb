require 'spec_helper'

describe Fundraiser do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:phone) }

  it "should validate other attributes when editing" do
    subject.stub(:new_record?) { false } 
    should validate_presence_of(:mission) 
    should validate_presence_of(:manager_title) 
    should validate_presence_of(:manager_email) 
    should validate_presence_of(:manager_name) 
    should validate_presence_of(:manager_phone) 
    should validate_presence_of(:supporter_demographics) 
  end

  it { should belong_to(:manager).class_name('User') }
  it { should have_one(:location).dependent(:destroy) }
  it { should have_one(:picture).dependent(:destroy) }
  it { should have_many(:users) }
  it { should have_many(:campaigns).dependent(:destroy) }
  it { should have_many(:pledges).through(:campaigns) }
  it { should have_many(:sponsors).through(:pledges) }

  it { should accept_nested_attributes_for(:location).update_only(true) }
  it { should accept_nested_attributes_for(:picture).update_only(true) }

  it "should validate presence of causes" do
    FactoryGirl.build(:fundraiser, causes: []).should have(1).error_on(:causes)
  end

  it "should build a picture if new object" do
    new_fundraiser = FactoryGirl.build(:fundraiser)
    new_fundraiser.picture.should_not be_nil
    new_fundraiser.picture.should be_instance_of(Picture)
  end

  it "should build a location if new object" do
    new_fundraiser = FactoryGirl.build(:fundraiser)
    new_fundraiser.location.should_not be_nil
    new_fundraiser.location.should be_instance_of(Location)
  end
end
