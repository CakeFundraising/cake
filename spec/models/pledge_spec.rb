require 'rails_helper'

describe Pledge do
  it { should validate_presence_of(:campaign) }
  it { should validate_presence_of(:website_url) }
  
  # it { should validate_numericality_of(:amount_per_click).with_message("must be an integer").is_greater_than(0).is_less_than_or_equal_to(1000) }
  # it { should validate_numericality_of(:total_amount).with_message("must be an integer").is_greater_than(0) }

  it "should validate other attributes when editing" do
    allow(subject).to receive(:persisted?){ true }
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
  it { should accept_nested_attributes_for(:sweepstakes) }

  it "should build a picture if new object" do
    new_pledge = FactoryGirl.build(:pledge)
    expect(new_pledge.picture).to_not be_nil
    expect(new_pledge.picture).to be_instance_of(Picture)
  end

  it "should have statuses" do
    expect(Pledge.statuses[:status]).to eq [:incomplete, :pending, :accepted, :rejected, :past]
  end

  describe "#max_clicks" do
    before(:each) do
      @pledge = FactoryGirl.create(:pledge)
    end

    it "should store the maximum quantity of clicks a pledge can ever have" do
      expect(@pledge.reload.max_clicks).to eq @pledge.current_max_clicks
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
        expect(@sponsor_active_pledges).to eq @active_pledges
      end

      it "should have active campaigns only" do
        @sponsor_active_pledges.each do |p|
          expect(p.campaign).to be_active
          expect(p.campaign).to_not be_past
        end
      end

      it "should return only accepted pledges" do
        expect(@sponsor_active_pledges).to_not include(@pending_pledges)
        expect(@sponsor_active_pledges).to_not include(@rejected_pledges)
      end
    end

    describe "Past Pledges" do
      it "should return a collection of past pledges for the sponsor" do
        expect(@sponsor_past_pledges).to eq @past_pledges
      end

      it "should have past campaigns only" do
        @sponsor_past_pledges.each do |p|
          expect(p.campaign).to be_past
          expect(p.campaign).to_not be_active
        end
      end

      it "should return only accepted pledges" do
        expect(@sponsor_past_pledges).to_not include(@pending_pledges)
        expect(@sponsor_past_pledges).to_not include(@rejected_pledges)
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
          expect(pledge).to be_valid
        end

        it "should not be valid if the total_amount is greater than campaign pledge levels max amount" do
          campaign = FactoryGirl.create(:campaign_with_pledge_levels)
          max = campaign.sponsor_categories.maximum(:max_value_cents)
          pledge = FactoryGirl.build(:pledge, campaign: campaign, total_amount_cents: max+20)
          expect(pledge).to_not be_valid
        end
      end

      context 'without pledge levels' do
        it "should be valid when the total_amount has any value" do
          pledge = FactoryGirl.build(:pledge, total_amount: '100000')
          expect(pledge).to be_valid
        end
      end
    end

    describe "#decreased_amounts" do
      before(:each) do
        @pledge = FactoryGirl.create(:pledge)
        @amount_per_click_cents = @pledge.amount_per_click_cents  
        @total_amount_cents = @pledge.total_amount_cents  
      end

      context 'increment' do
        it "should be valid if the total_amount is increased" do
          @pledge.total_amount_cents = @total_amount_cents + 200
          expect(@pledge).to be_valid
        end

        it "should be valid if the amount_per_click is increased" do
          @pledge.amount_per_click_cents = @amount_per_click_cents + 200
          expect(@pledge).to be_valid
        end

        it "should be valid if the amount_per_click are increased" do
          @pledge.total_amount_cents = @total_amount_cents + 200
          @pledge.amount_per_click_cents = @amount_per_click_cents + 200
          expect(@pledge).to be_valid
        end
      end

      context 'decrement' do
        it "should not be valid if the total_amount is decreased" do
          @pledge.total_amount_cents = @total_amount_cents - 200
          expect(@pledge).to_not be_valid
        end

        it "should not be valid if the amount_per_click is decreased" do
          @pledge.amount_per_click_cents = @amount_per_click_cents - 200
          expect(@pledge).to_not be_valid
        end
      end
    end
  end

  describe "#clicks" do
    before(:each) do
      @pledge = FactoryGirl.create(:not_clicked_pledge)  
      @browser = FactoryGirl.create(:browser)
    end

    context 'Click Action' do
      it "should store a unique click if the user has not clicked before" do
        click = FactoryGirl.build(:click, pledge: @pledge, browser: @browser)
        expect( click.save ).to be true
        expect( click.bonus ).to be false
      end

      it "should store a unique click when the click is in another pledge" do
        clicks = create_list(:click, 5, pledge: @pledge, browser: @browser)

        pledge = FactoryGirl.create(:not_clicked_pledge)  
        click = FactoryGirl.build(:click, pledge: pledge, browser: @browser)
        
        expect( click.save ).to be true
        expect( click.bonus ).to be false
      end

      it "should store a bonus click if the user has clicked before in that pledge" do
        clicks = create_list(:click, 5, pledge: @pledge, browser: @browser)

        click = FactoryGirl.build(:bonus_click, pledge: @pledge, browser: @browser)

        expect( click.save ).to be true
        expect( click.bonus ).to be true
      end
    end

    context 'Pledge fully subscribed' do
      it "should store a unique click if the pledge is not fully subscribed" do
        clicks = create_list(:click, @pledge.max_clicks - 1, pledge: @pledge)
        click = FactoryGirl.create(:click, pledge: @pledge) 

        expect( click.bonus ).to be false
      end

      it "should store a bonus click if the pledge is fully subscribed" do
        clicks = create_list(:click, @pledge.max_clicks, pledge: @pledge)
        click = FactoryGirl.create(:bonus_click, pledge: @pledge) 

        expect( click.bonus ).to be true
      end
    end

    context 'Methods' do
      describe "#fully_subscribed?" do
        it "should return true when the pledge reaches the total amount" do
          allow(@pledge).to receive(:clicks_count){ @pledge.max_clicks }
          expect( @pledge.fully_subscribed? ).to be true
        end

        it "should return false when the pledge has not reached the total amount" do
          allow(@pledge).to receive(:clicks_count){ @pledge.max_clicks - 1 }
          expect( @pledge.fully_subscribed? ).to be false
        end
      end

      describe "#click_exists?" do
        it "should return false if pledge doesn't have an equal click to the given one" do
          click = FactoryGirl.create(:click, pledge: @pledge, browser: @browser)

          another_browser = FactoryGirl.create(:browser)
          another_click = FactoryGirl.build(:click, browser: another_browser)

          expect( @pledge.click_exists?(another_click) ).to be false
        end

        it "should return true if the pledge has the same click than the given one" do
          click = FactoryGirl.create(:click, pledge: @pledge, browser: @browser)
          another_click = FactoryGirl.build(:click, browser: @browser)

          expect( @pledge.click_exists?(another_click) ).to be true
        end
      end
    end

  end

end