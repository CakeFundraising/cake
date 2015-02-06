require 'rails_helper'

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
    expect(new_pledge.picture).to_not be_nil
    expect(new_pledge.picture).to be_instance_of(Picture)
  end

  it "should have statuses" do
    expect(QuickPledge.statuses[:status]).to eq [:incomplete, :confirmed, :past]
  end
end
