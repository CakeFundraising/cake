require 'spec_helper'

describe Campaign do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:launch_date) }
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:fundraiser) }

  it { should belong_to(:fundraiser) }
  it { should have_one(:picture).dependent(:destroy) }
  it { should have_one(:video).dependent(:destroy) }
  it { should have_many(:sponsor_categories).dependent(:destroy) }
  it { should have_many(:pledge_requests).dependent(:destroy) }
  it { should have_many(:pledges).dependent(:destroy) }
  it { should have_many(:invoices).through(:pledges) }

  it { should have_many(:direct_donations).dependent(:destroy) }

  it { should accept_nested_attributes_for(:picture).update_only(true) }
  it { should accept_nested_attributes_for(:video).update_only(true) }
  it { should accept_nested_attributes_for(:sponsor_categories) }

  it "should validate other attributes when persisted" do
    subject.stub(:persisted?) { true } 
    should validate_presence_of(:headline)
    should validate_presence_of(:mission)
    should validate_presence_of(:story)
  end

  it "should validate presence of causes" do
    FactoryGirl.build(:campaign, causes: []).should have(1).error_on(:causes)
  end

  it "should build a picture if new object" do
    new_campaign = FactoryGirl.build(:campaign)
    new_campaign.picture.should_not be_nil
    new_campaign.picture.should be_instance_of(Picture)
  end

  it "should have statuses" do
    Campaign.statuses[:status].should == [:inactive, :live]
  end

  context 'Actions' do
    describe "#launch" do
      before(:each) do
        @campaign = FactoryGirl.create(:inactive_campaign)
      end

      it "should set a live status" do
        @campaign.status.should == :inactive
        @campaign.launch!
        @campaign.status.should == :live
      end
    end
  end

  context 'Activity Status' do
    #Scopes
    it "should return a collection of active campaigns" do
      @campaigns = create_list(:campaign, 5)
      Campaign.active.should == @campaigns
    end

    it "should return a collection of past campaigns" do
      @campaigns = create_list(:past_campaign, 5)
      Campaign.past.should == @campaigns
    end
    
    #Conditions
    it "should show whether a campaign is active" do
      campaign = FactoryGirl.create(:campaign)
      campaign.should be_active
      campaign.should_not be_past
    end

    it "should show whether a campaign is past" do
      campaign = FactoryGirl.create(:past_campaign)
      campaign.should be_past
      campaign.should_not be_active 
    end
  end

  context 'scopes' do
    before(:each) do
      @campaigns = create_list(:past_campaign, 5)
      @campaigns.each do |c|
        create_list(:pledge, 5, campaign: c)
        c.pledges.accepted.each(&:create_invoice)
      end
    end

    describe "with_paid_invoices" do
      it "should not include unpaid invoices" do
        Campaign.with_paid_invoices.should be_empty
      end

      it "should include only paid invoices" do
        @campaigns.first.invoices.update_all(status: :paid)

        Campaign.with_paid_invoices.count.should == 1
        Campaign.with_paid_invoices.map(&:invoices).flatten.each do |invoice|
          invoice.status.should == "paid"
        end
      end
    end

    describe "with_outstanding_invoices" do
      it "should include not paid invoices" do
        Campaign.with_outstanding_invoices.count.should == 5
        Campaign.with_outstanding_invoices.map(&:invoices).flatten.each do |invoice|
          invoice.status.should_not == "paid"
        end
      end

      it "should not include paid invoices" do
        @campaigns.first.invoices.update_all(status: :paid)

        Campaign.with_paid_invoices.count.should == 1
        
        Campaign.with_outstanding_invoices.count.should == 4
        Campaign.with_outstanding_invoices.map(&:invoices).flatten.each do |invoice|
          invoice.status.should_not == "paid"
        end
      end
    end
  end

  describe "Sponsor Categories" do
    context 'collection' do
      before(:each) do
        @campaign = FactoryGirl.create(:campaign)

        @top_sponsor_category = FactoryGirl.create(:sponsor_category, campaign: @campaign, name: "top", min_value_cents: 50000, max_value_cents: 100000)
        @medium_sponsor_category = FactoryGirl.create(:sponsor_category, campaign: @campaign, name: "medium", min_value_cents: 25000, max_value_cents: 50000)
        @low_sponsor_category = FactoryGirl.create(:sponsor_category, campaign: @campaign, name: "low", min_value_cents: 100, max_value_cents: 25000)

        @top_pledges, @medium_pledges, @low_pledges = [], [], []
        3.times do
          @top_pledges << FactoryGirl.create(:pledge, campaign: @campaign, total_amount_cents: rand(50000..100000) )
          @medium_pledges << FactoryGirl.create(:pledge, campaign: @campaign, total_amount_cents: rand(25000...50000) )
          @low_pledges << FactoryGirl.create(:pledge, campaign: @campaign, total_amount_cents: rand(100...25000)   )
        end

        @campaign.sponsor_categories.reload
        @campaign.rank_levels
      end
      
      it "should return the pledges ranked according to the pledge levels" do
        @campaign.top_pledges.should  match_array(@top_pledges)
        @campaign.medium_pledges.should match_array(@medium_pledges)
        @campaign.low_pledges.should match_array(@low_pledges)
      end

      it "should order the pledges inside the same sponshoship level" do
        @campaign.top_pledges.should == @top_pledges.sort_by{|p| -p.total_amount_cents }
        @campaign.medium_pledges.should == @medium_pledges.sort_by{|p| -p.total_amount_cents }
        @campaign.low_pledges.should == @low_pledges.sort_by{|p| -p.total_amount_cents }
      end
    end

    # context 'Validation' do
    #   it "should not validate sponsor_categories when there are not custom pledge levels" do
    #     @campaign = FactoryGirl.build(:campaign, custom_pledge_levels: false)
    #     @campaign.should be_valid
    #   end

    #   it "should validate sponsor_categories when there are custom pledge levels" do
    #     @campaign = FactoryGirl.build(:campaign)
    #     @campaign.should_not be_valid
    #   end
    # end
  end

end
