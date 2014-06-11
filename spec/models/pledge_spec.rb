require 'spec_helper'

describe Pledge do
  it { should validate_presence_of(:campaign) }
  it { should validate_presence_of(:website_url) }
  
  # it { should validate_numericality_of(:amount_per_click).with_message("must be an integer").is_greater_than(0).is_less_than_or_equal_to(1000) }
  # it { should validate_numericality_of(:total_amount).with_message("must be an integer").is_greater_than(0) }

  it "should validate other attributes when editing" do
    subject.stub(:persisted?){ true } 
    should validate_presence_of(:mission) 
    should validate_presence_of(:headline) 
    should validate_presence_of(:description) 
  end

  it { should belong_to(:sponsor) }
  it { should belong_to(:campaign) }
  it { should have_one(:fundraiser).through(:campaign) }
  it { should have_one(:picture).dependent(:destroy) }
  it { should have_one(:video).dependent(:destroy) }
  it { should have_one(:invoice) }
  it { should have_many(:coupons).dependent(:destroy) }
  it { should have_many(:sweepstakes).dependent(:destroy) }
  it { should have_many(:clicks).dependent(:destroy) }

  it { should accept_nested_attributes_for(:picture).update_only(true) }
  it { should accept_nested_attributes_for(:video).update_only(true) }
  it { should accept_nested_attributes_for(:coupons) }
  it { should accept_nested_attributes_for(:sweepstakes) }

  it "should build a picture if new object" do
    new_pledge = FactoryGirl.build(:pledge)
    new_pledge.picture.should_not be_nil
    new_pledge.picture.should be_instance_of(Picture)
  end

  it "should have statuses" do
    Pledge.statuses[:status].should == [:pending, :accepted, :rejected]
  end

  describe "#max_clicks" do
    before(:each) do
      @pledge = FactoryGirl.create(:pledge)
    end

    it "should store the maximum quantity of clicks a pledge can ever have" do
      @pledge.reload.max_clicks.should == @pledge.current_max_clicks
    end

    it "should be updated when the total_amount changes" do
      expect{ 
        @pledge.update_attribute(:total_amount_cents, "999.00")
      }.to change{ @pledge.max_clicks }
    end

    it "should be updated when the amount_per_click changes" do
      expect{ 
        @pledge.update_attribute(:amount_per_click_cents, "7.00")
      }.to change{ @pledge.max_clicks }
    end
  end

  context 'Activity status' do
    before(:each) do
      @sponsor = FactoryGirl.create(:sponsor)
      @active_pledges = create_list(:pledge, 3, sponsor: @sponsor)
      @past_pledges = create_list(:past_pledge, 3, sponsor: @sponsor)
      @pending_pledges = create_list(:pending_pledge, 3, sponsor: @sponsor)
      @rejected_pledges = create_list(:rejected_pledge, 3, sponsor: @sponsor)

      @sponsor_active_pledges = @sponsor.pledges.active
      @sponsor_past_pledges = @sponsor.pledges.past
    end

    describe "Active Pledges" do
      it "should return a collection of active pledges for the sponsor" do
        @sponsor_active_pledges.should == @active_pledges
      end

      it "should have active campaigns only" do
        @sponsor_active_pledges.each do |p|
          p.campaign.should be_active
          p.campaign.should_not be_past        
        end
      end

      it "should return only accepted pledges" do
        @sponsor_active_pledges.should_not include(@pending_pledges)
        @sponsor_active_pledges.should_not include(@rejected_pledges)
      end
    end

    describe "Past Pledges" do
      it "should return a collection of past pledges for the sponsor" do
        @sponsor_past_pledges.should == @past_pledges
      end

      it "should have past campaigns only" do
        @sponsor_past_pledges.each do |p|
          p.campaign.should be_past
          p.campaign.should_not be_active 
        end
      end

      it "should return only accepted pledges" do
        @sponsor_past_pledges.should_not include(@pending_pledges)
        @sponsor_past_pledges.should_not include(@rejected_pledges)
      end
    end
    
  end

  context 'validations' do
    describe "#max_amount" do
      context 'with pledge levels' do
        it "should be valid if the total_amount is less than campaign pledge levels max amount" do
          campaign = FactoryGirl.create(:campaign_with_pledge_levels)
          max = campaign.sponsor_categories.maximum(:max_value_cents)
          pledge = FactoryGirl.build(:pledge, campaign: campaign, total_amount_cents: max-20)
          pledge.should be_valid
        end

        it "should not be valid if the total_amount is greater than campaign pledge levels max amount" do
          campaign = FactoryGirl.create(:campaign_with_pledge_levels)
          max = campaign.sponsor_categories.maximum(:max_value_cents)
          pledge = FactoryGirl.build(:pledge, campaign: campaign, total_amount_cents: max+20)
          pledge.should_not be_valid
        end
      end

      context 'without pledge levels' do
        it "should be valid when the total_amount has any value" do
          pledge = FactoryGirl.build(:pledge, total_amount: '100000')
          pledge.should be_valid
        end
      end
    end
  end

  describe "#clicks" do
    before(:each) do
      @pledge = FactoryGirl.create(:pledge)  
    end

    it "should store the click if the user has not clicked before" do
      @click = @pledge.clicks.build(request_ip: "253.187.158.63")
      @pledge.should be_valid
    end

    it "should not store a click if the user has clicked before" do
      @clicks = create_list(:click, 5, pledge: @pledge)
      ip = @clicks.first.request_ip

      @click = @pledge.clicks.build(request_ip: ip)
      @pledge.should_not be_valid
    end

    it "should store a click if the pledge is not fully subscribed" do
      @clicks = create_list(:click, @pledge.max_clicks - 1, pledge: @pledge)

      @pledge.clicks.build(request_ip: "253.187.158.63") 
      @pledge.should be_valid
    end

    it "should not store a click if the pledge is fully subscribed" do
      @clicks = create_list(:click, @pledge.max_clicks, pledge: @pledge)

      @pledge.clicks.build(request_ip: "253.187.158.63") 
      @pledge.should_not be_valid
    end

    context 'Methods' do
      describe "#have_donated?" do
        it "should return false if ip is not present in the clicks" do
          @pledge.have_donated?("253.187.158.63").should be_false
        end

        it "should return true if ip is present in the clicks" do
          @clicks = create_list(:click, 5, pledge: @pledge)
          ip = @clicks.first.request_ip

          @pledge.reload.have_donated?(ip).should be_true
        end
      end

      describe "#fully_subscribed?" do
        it "should return true when the pledge reaches the total amount" do
          @clicks = create_list(:click, @pledge.max_clicks, pledge: @pledge)
          @pledge.fully_subscribed?.should be_true
        end

        it "should return false when the pledge has not reached the total amount" do
          total_clicks = @pledge.max_clicks - 1
          @clicks = create_list(:click, total_clicks, pledge: @pledge)
          @pledge.fully_subscribed?.should be_false
        end
      end

      describe "#clicks_count" do
        it "should update the counter when adding new clicks" do
          @clicks = create_list(:click, 5, pledge: @pledge)
          @pledge.reload.clicks_count.should == 5
        end

        it "should update the counter when deleting clicks from collection" do
          @clicks = create_list(:click, 5, pledge: @pledge)
          @clicks.first.destroy
          @pledge.reload.clicks_count.should == 4
        end
      end
    end

  end

end