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
        levels = Hash[
          @campaign.sponsor_categories.map{|sc| [sc.name, (sc.min_value_cents..sc.max_value_cents) ] }
        ]

        @campaign.sponsor_categories.levels.should == levels
      end
    end
  end
end
