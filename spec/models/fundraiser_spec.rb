require 'spec_helper'

describe Fundraiser do
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
    should validate_presence_of(:supporter_demographics) 
  end

  it { should belong_to(:manager).class_name('User') }
  it { should have_one(:location).dependent(:destroy) }
  it { should have_one(:picture).dependent(:destroy) }
  it { should have_one(:stripe_account).dependent(:destroy) }
  it { should have_many(:users) }
  it { should have_many(:pledge_requests).dependent(:destroy) }
  it { should have_many(:campaigns).dependent(:destroy) }
  it { should have_many(:pledges).through(:campaigns) }
  it { should have_many(:invoices).through(:pledges) }

  it { should accept_nested_attributes_for(:location).update_only(true) }
  it { should accept_nested_attributes_for(:picture).update_only(true) }

  it "should validate presence of causes" do
    FactoryGirl.build(:fundraiser, causes: []).should have(1).error_on(:causes)
  end

  it "should build a picture if new object" do
    new_fundraiser = FactoryGirl.build(:fundraiser)
    new_fundraiser.picture.should_not be_nil
    new_fundraiser.picture.should be_instance_of(Picture)
  end

  it "should build a location if new object" do
    new_fundraiser = FactoryGirl.build(:fundraiser)
    new_fundraiser.location.should_not be_nil
    new_fundraiser.location.should be_instance_of(Location)
  end

  context 'Association methods' do
    let(:fundraiser){ FactoryGirl.create(:fundraiser) }
    let(:campaigns){ create_list(:campaign, 5, fundraiser: fundraiser) }

    describe "Pledges" do
      it "should show a collection of fundraiser's accepted pledges" do
        accepted_pledges = create_list(:pledge, 10, campaign: campaigns.sample)
        fundraiser.pledges.accepted.reload.should == accepted_pledges
      end

      it "should show a collection of fundraiser's pending pledges" do
        pending_pledges = create_list(:pending_pledge, 10, campaign: campaigns.sample)
        fundraiser.pledges.pending.reload.should == pending_pledges
      end

      it "should show a collection of fundraiser's rejected pledges" do
        rejected_pledges = create_list(:rejected_pledge, 10, campaign: campaigns.sample)
        fundraiser.pledges.rejected.reload.should == rejected_pledges
      end
    end

    describe "Sponsors" do
      # Sponsors are the sponsors of FR's accepted pledges
      it "should show a collection of fundraiser's sponsors" do
        accepted_pledges = create_list(:pledge, 10, campaign: campaigns.sample)
        pending_pledges = create_list(:pending_pledge, 10, campaign: campaigns.sample)
        rejected_pledges = create_list(:rejected_pledge, 10, campaign: campaigns.sample)

        fundraiser.sponsors.should == accepted_pledges.map(&:sponsor)
        fundraiser.sponsors.should_not include(pending_pledges.map(&:sponsor))
        fundraiser.sponsors.should_not include(rejected_pledges.map(&:sponsor))
      end
    end
  end
end
