require 'spec_helper'

describe PledgeRequest do
  it { should belong_to(:sponsor) }
  it { should belong_to(:campaign) }
  it { should belong_to(:fundraiser) }

  it { should validate_presence_of(:sponsor) }
  it { should validate_presence_of(:campaign) }
  it { should validate_presence_of(:fundraiser) }

  it "should have statuses" do
    PledgeRequest.statuses[:status].should == [:pending, :accepted, :rejected]
  end
end
