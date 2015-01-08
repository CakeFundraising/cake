require 'rails_helper'

describe Campaign do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:launch_date) }
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:fundraiser) }
  it { should validate_presence_of(:main_cause) }

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

  it "should build a picture if new object" do
    new_campaign = FactoryGirl.build(:campaign)
    new_campaign.picture.should_not be_nil
    new_campaign.picture.should be_instance_of(Picture)
  end

  it "should have statuses" do
    Campaign.statuses[:status].should == [:incomplete, :pending, :launched, :past]
  end

  context 'Actions' do
    describe "#pending!" do
      before(:each) do
        @campaign = FactoryGirl.create(:incomplete_campaign)
      end

      it "should set a pending status" do
        @campaign.status.should == :incomplete
        @campaign.pending!
        @campaign.status.should == :pending
      end
    end

    describe "#launch!" do
      before(:each) do
        @campaign = FactoryGirl.create(:pending_campaign)
      end

      it "should set a launched status" do
        @campaign.status.should == :pending
        @campaign.launch!
        @campaign.status.should == :launched
      end
    end

    describe "#end" do
      before(:each) do
        @campaign = FactoryGirl.create(:campaign)
        @active_pledges = create_list(:pledge, 3, campaign: @campaign)
        @pending_pledges = create_list(:pending_pledge, 3, campaign: @campaign)
      end

      it "should generate invoices for accepted pledges" do
        expect{
          @campaign.end
        }.to change{Invoice.count}.by(@active_pledges.count)
      end

      it "should set all pledges as past" do
        @campaign.end
        @campaign.pledges.sort.should == @campaign.pledges.past.sort
        @campaign.pledges.past.count.should == (@active_pledges+@pending_pledges).count
      end

      it "should set the campaign as past" do
        expect{
          @campaign.end
        }.to change{@campaign.status}.to :past
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

  describe "Sponsor Categories" do
    context 'collection' do
      before(:each) do
        @campaign = FactoryGirl.create(:campaign)
        @campaign.sponsor_categories.destroy_all

        @top_sponsor_category = FactoryGirl.create(:sponsor_category, campaign: @campaign, name: "top", min_value_cents: 50000, max_value_cents: 100000)
        @medium_sponsor_category = FactoryGirl.create(:sponsor_category, campaign: @campaign, name: "medium", min_value_cents: 25000, max_value_cents: 50000)
        @low_sponsor_category = FactoryGirl.create(:sponsor_category, campaign: @campaign, name: "low", min_value_cents: 100, max_value_cents: 25000)

        @top_pledges, @medium_pledges, @low_pledges = [], [], []
        3.times do
          @top_pledges << FactoryGirl.create(:pledge, campaign: @campaign, total_amount_cents: rand(50000..100000) )
          @medium_pledges << FactoryGirl.create(:pledge, campaign: @campaign, total_amount_cents: rand(25000...50000) )
          @low_pledges << FactoryGirl.create(:pledge, campaign: @campaign, total_amount_cents: rand(10000...25000)   )
        end

        @campaign.sponsor_categories.reload
        @campaign.rank_levels
      end

      context 'pledge levels' do
        it "should return the pledges ranked according to the pledge levels" do
          @campaign.top_pledges.should  match_array(@top_pledges)
          @campaign.medium_pledges.should match_array(@medium_pledges)
          @campaign.low_pledges.should match_array(@low_pledges)
        end
      end

      context 'same pledge level' do
        it "should order the pledges based upon the total_amount" do
          @campaign.top_pledges.should == @top_pledges.sort_by{|p| -p.total_amount_cents }
          @campaign.medium_pledges.should == @medium_pledges.sort_by{|p| -p.total_amount_cents }
          @campaign.low_pledges.should == @low_pledges.sort_by{|p| -p.total_amount_cents }
        end

        it "should order the pledges based upon the amount_per_click when 2 pledges have the same total_amount" do
          @top_pledges = []
          @campaign.pledges.delete_all
          @top_pledges << FactoryGirl.create(:pledge, campaign: @campaign, total_amount_cents: 60000, amount_per_click: '2.5')
          @top_pledges << FactoryGirl.create(:pledge, campaign: @campaign, total_amount_cents: 60000, amount_per_click: '2.7')

          @campaign.top_pledges.should == @top_pledges.sort_by{|p| -p.amount_per_click_cents }
        end
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

  context 'Analytics' do
    before(:each) do
      @campaign = FactoryGirl.create(:campaign)
    end

    describe "Total Donation" do
      before(:each) do
        @invoices = create_list(:invoice, 5, campaign: @campaign)
        @pending_invoices = create_list(:pending_invoice, 5, campaign: @campaign)
      end

      it "should show total dollars collected by all FR paid campaigns's invoices" do
        total = @invoices.map(&:due_cents).sum
        expect( @campaign.total_donation ).to eql(total)
      end

      it "should not include dollars coming from pending invoices" do
        total = @pending_invoices.map(&:due_cents).sum
        expect( @campaign.total_donation ).not_to eql(total)
      end
    end

    describe "Average Donation" do
      before(:each) do
        @past_pledges = create_list(:past_pledge, 5, campaign: @campaign)

        @paid_invoices = []
        @outstanding_invoices = []

        @past_pledges.each do |pledge|
          @paid_invoices << create_list(:invoice, 3, pledge: pledge)
          @outstanding_invoices << create_list(:pending_invoice, 5, pledge: pledge)
        end
        @paid_invoices = @paid_invoices.flatten
        @outstanding_invoices = @outstanding_invoices.flatten
      end

      it "should sum up all paid invoices's donations given to campaign" do
        avg = @paid_invoices.map(&:due_cents).sum/@paid_invoices.count
        expect( @campaign.average_donation ).to eql(avg)
      end

      it "should not include outstanding invoices's donations" do
        avg = @outstanding_invoices.map(&:due_cents).sum/@outstanding_invoices.count
        expect( @campaign.average_donation ).not_to eql(avg)
      end
    end

    describe "Average Pledge" do
      before(:each) do
        @pending_pledges = create_list(:pending_pledge, 2, campaign: @campaign)
        @rejected_pledges = create_list(:rejected_pledge, 3, campaign: @campaign)
        @accepted_pledges = create_list(:pledge, 4, campaign: @campaign)
        @past_pledges = create_list(:past_pledge, 5, campaign: @campaign)
      end

      it "should be the sum of all pledges/number of pledges" do
        pledges = @accepted_pledges + @past_pledges
        avg = pledges.map(&:total_amount_cents).sum/pledges.count
        expect( @campaign.average_pledge ).to eql(avg)
      end
    end

    describe "Average Donation per Click" do
      before(:each) do
        @pending_pledges = create_list(:pending_pledge, 2, campaign: @campaign)
        @rejected_pledges = create_list(:rejected_pledge, 3, campaign: @campaign)
        @accepted_pledges = create_list(:pledge, 4, campaign: @campaign)
        @past_pledges = create_list(:past_pledge, 5, campaign: @campaign)
      end

      it "should be the average of accepted and past pledges's amount_per_click" do
        pledges = @accepted_pledges + @past_pledges
        avg = pledges.map(&:amount_per_click_cents).sum/pledges.count
        expect( @campaign.average_donation_per_click ).to eql(avg)
      end
    end

    describe "Average Clicks per Pledge" do
      before(:each) do
        @accepted_pledges = create_list(:pledge, 4, campaign: @campaign, clicks_count: 0)
        @past_pledges = create_list(:past_pledge, 5, campaign: @campaign, clicks_count: 0)
        @pledges = @accepted_pledges + @past_pledges

        @pledges.each do |p|
          create_list(:click, 5, pledge: p)
          p.update_attribute(:clicks_count, 5)
        end
      end

      it "should be the total clicks divided total of accepted and past pledges" do
        avg = @pledges.map(&:clicks).flatten.count/@pledges.count
        expect( @campaign.average_clicks_per_pledge ).to eql(avg)
      end
    end

  end

end
