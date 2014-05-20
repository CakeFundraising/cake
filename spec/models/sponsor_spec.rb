require 'spec_helper'

describe Sponsor do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:phone) }
  
  it "should validate other attributes when editing" do
    subject.stub(:new_record?) { false } 
    should validate_presence_of(:mission) 
    should validate_presence_of(:manager_title) 
    should validate_presence_of(:manager_email) 
    should validate_presence_of(:manager_name) 
    should validate_presence_of(:manager_phone) 
    should validate_presence_of(:customer_demographics) 
  end

  it { should belong_to(:manager).class_name('User') }
  it { should have_one(:location).dependent(:destroy) }
  it { should have_one(:picture).dependent(:destroy) }
  it { should have_many(:users) }
  it { should have_many(:pledge_requests).dependent(:destroy) }
  it { should have_many(:pledges).dependent(:destroy) }
  it { should have_many(:campaigns).through(:pledges) }
  it { should have_many(:invoices).through(:pledges) }

  it { should accept_nested_attributes_for(:location).update_only(true) }
  it { should accept_nested_attributes_for(:picture).update_only(true) }

  # it "should validate presence of causes" do
  #   FactoryGirl.build(:sponsor, causes: []).should have(1).error_on(:causes)
  # end

  # it "should validate presence of scopes" do
  #   FactoryGirl.build(:sponsor, scopes: []).should have(1).error_on(:scopes)
  # end

  # it "should validate presence of cause_requirements" do
  #   FactoryGirl.build(:sponsor, cause_requirements: []).should have(1).error_on(:cause_requirements)
  # end

  it "should build a picture if new object" do
    new_sponsor = FactoryGirl.build(:sponsor)
    new_sponsor.picture.should_not be_nil
    new_sponsor.picture.should be_instance_of(Picture)
  end

  it "should build a location if new object" do
    new_sponsor = FactoryGirl.build(:sponsor)
    new_sponsor.location.should_not be_nil
    new_sponsor.location.should be_instance_of(Location)
  end

  context 'Statistic methods' do
    before(:each) do
      @sponsor = FactoryGirl.create(:sponsor)
      @pledges = create_list(:pledge, 5, sponsor: @sponsor)
    end
    
    describe "#total_donation" do
      it "should return the total donation for all accepted pledges" do
        @sponsor.total_donation.should == @pledges.map(&:total_amount).sum
      end
    end

    # describe "#rank" do
    #   before(:each) do
    #     @sponsors = create_list(:sponsor, 5)
    #     @sponsors.each_with_index{|s, i| s.stub(:total_donation){ i+1 } }
    #   end

    #   it "should return the rank position number of the sponsor" do
    #     sponsor.stub(:total_donation){0}
    #     sponsor.rank.should == 6
    #   end
    # end

  end

  context 'Association methods' do
    before(:each) do
      @sponsor = FactoryGirl.create(:sponsor)
    end

    describe "Pledges" do
      it "should show a collection of sponsor's active pledges" do
        active_pledges = create_list(:pledge, 10, sponsor: @sponsor)
        @sponsor.pledges.active.should == active_pledges
      end

      it "should show a collection of sponsor's pending pledges" do
        pending_pledges = create_list(:pending_pledge, 10, sponsor: @sponsor)
        @sponsor.pledges.pending.should == pending_pledges
      end

      it "should show a collection of sponsor's rejected pledges" do
        rejected_pledges = create_list(:rejected_pledge, 10, sponsor: @sponsor)
        @sponsor.pledges.rejected.should == rejected_pledges
      end
    end

    describe "Fundraisers" do
      # Fundraisers are the FR of the pledges's campaigns
      it "should show a collection of sponsor's fundraisers" do
        accepted_pledges = create_list(:pledge, 10, sponsor: @sponsor)
        pending_pledges = create_list(:pending_pledge, 10, sponsor: @sponsor)
        rejected_pledges = create_list(:rejected_pledge, 10, sponsor: @sponsor)

        @sponsor.fundraisers.should == accepted_pledges.map(&:fundraiser)
        @sponsor.fundraisers.should_not include(pending_pledges.map(&:fundraiser))
        @sponsor.fundraisers.should_not include(rejected_pledges.map(&:fundraiser))
      end
    end
  end
end
