require 'rails_helper'

describe SponsorCategory do
  it { should belong_to(:campaign) }
  it { should validate_presence_of(:name) }

  context 'Methods' do
    describe "#levels" do
      before(:each) do
        @campaign = FactoryGirl.build(:campaign)
        @campaign.sponsor_categories << FactoryGirl.build(:sponsor_category, min_value_cents: 50000, max_value_cents: 100000)
        @campaign.sponsor_categories << FactoryGirl.build(:sponsor_category, min_value_cents: 25000, max_value_cents: 49999)
        @campaign.sponsor_categories << FactoryGirl.build(:sponsor_category, min_value_cents: 100, max_value_cents: 24999)    
        @campaign.save
      end

      it "should return the pledge levels for the campaign" do
        levels = Hash[
          @campaign.sponsor_categories.map{|sc| [sc.name, (sc.min_value_cents..sc.max_value_cents) ] }
        ]

        @campaign.sponsor_categories.levels.should == levels
      end
    end
  end

  context 'Validation' do
    before(:each) do
      @campaign = FactoryGirl.build(:campaign_with_pledge_levels)
    end

    # it "should validate overlapping between min and max amounts" do
    #   @campaign.sponsor_categories << FactoryGirl.build(:sponsor_category, min_value_cents: 50000, max_value_cents: 100000)
    #   @campaign.sponsor_categories << FactoryGirl.build(:sponsor_category, min_value_cents: 25000, max_value_cents: 50000)
    #   @campaign.sponsor_categories << FactoryGirl.build(:sponsor_category, min_value_cents: 100, max_value_cents: 25000)  

    #   @campaign.should_not be_valid
    #   @campaign.errors.messages[:sponsor_categories].should include('The max and min values must not overlap.')
    # end

    it "should validate max value greater than min value" do
      @campaign.sponsor_categories << FactoryGirl.build(:sponsor_category, min_value_cents: 50000, max_value_cents: 10000)
      @campaign.should_not be_valid
      @campaign.errors.messages[:'sponsor_categories.max_value'].should include('must be greater than Min value.')
    end
  end
end
