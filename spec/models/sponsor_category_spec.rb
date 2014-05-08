require 'spec_helper'

describe SponsorCategory do
  it { should belong_to(:campaign) }
  it { should validate_presence_of(:name) }

  context 'Methods' do
    describe "#levels" do
      before(:each) do
        @campaign = FactoryGirl.create(:campaign_with_pledge_levels)  
      end

      it "should return the pledge levels for the campaign" do
        @campaign.sponsor_categories.levels.should == @campaign.sponsor_categories.map(&:name)
      end
    end
  end
end
