require 'spec_helper'

describe Campaign do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:launch_date) }
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:headline) }
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:fundraiser) }

  it { should belong_to(:fundraiser) }
  it { should have_one(:picture).dependent(:destroy) }
  it { should have_one(:video).dependent(:destroy) }
  it { should have_many(:sponsor_categories).dependent(:destroy) }
  it { should have_many(:pledges).dependent(:destroy) }

  it { should accept_nested_attributes_for(:picture).update_only(true) }
  it { should accept_nested_attributes_for(:video).update_only(true) }
  it { should accept_nested_attributes_for(:sponsor_categories) }

  it "should validate presence of causes" do
    FactoryGirl.build(:campaign, causes: []).should have(1).error_on(:causes)
  end

  it "should build a picture if new object" do
    new_campaign = FactoryGirl.build(:campaign)
    new_campaign.picture.should_not be_nil
    new_campaign.picture.should be_instance_of(Picture)
  end
end
