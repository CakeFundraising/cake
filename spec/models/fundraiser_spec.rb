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
    let!(:fundraiser){ FactoryGirl.create(:fundraiser) }

    describe "Pledges" do
      let!(:campaigns){ create_list(:campaign, 5, fundraiser: fundraiser) }
      
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
      let!(:campaigns){ create_list(:campaign, 5, fundraiser: fundraiser) }
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

    context 'Campaigns' do
      let!(:included_campaign){ FactoryGirl.create(:past_campaign, fundraiser: fundraiser) }
      let!(:not_included_campaign){ FactoryGirl.create(:past_campaign, fundraiser: fundraiser) }

      let!(:included_pledge){ FactoryGirl.create(:pledge, campaign: included_campaign) }
      let!(:not_included_pledge){ FactoryGirl.create(:pledge, campaign: not_included_campaign) }

      describe "with_paid_invoices" do
        it "should not return any campaign if there isn't invoices created" do
          fundraiser.campaigns.with_paid_invoices.should be_empty
        end
        
        context 'invoices present' do
          let!(:paid_invoice){ FactoryGirl.create(:invoice, pledge: included_pledge, status: :paid) }
          let!(:not_paid_invoice){ FactoryGirl.create(:invoice, pledge: not_included_pledge, status: :due_to_pay) }

          it "should not include campaigns with unpaid invoices" do
            fundraiser.campaigns.with_paid_invoices.should_not include(not_included_campaign)
          end

          it "should include only campaigns with paid invoices" do
            fundraiser.campaigns.with_paid_invoices.should == [included_campaign]
          end

          context 'should not include a campaign with both paid and unpaid invoices' do
            it "when invoices is due to pay" do
              not_included_invoice = FactoryGirl.create(:invoice, pledge: included_pledge, status: :due_to_pay)

              included_campaign.invoices.should include(paid_invoice)
              included_campaign.invoices.should include(not_included_invoice)
              fundraiser.campaigns.with_paid_invoices.should_not include(included_campaign)
            end

            it "when invoices is in arbitration" do
              not_included_invoice = FactoryGirl.create(:invoice, pledge: included_pledge, status: :in_arbitration)

              included_campaign.invoices.should include(paid_invoice)
              included_campaign.invoices.should include(not_included_invoice)
              fundraiser.campaigns.with_paid_invoices.should_not include(included_campaign)
            end
          end
        end
      end

      describe "with_outstanding_invoices" do
        it "should not return any campaign if there isn't invoices" do
          fundraiser.campaigns.with_outstanding_invoices.should be_empty
        end

        context 'invoices present' do
          let!(:not_paid_invoice){ FactoryGirl.create(:invoice, pledge: included_pledge, status: :due_to_pay) }
          let!(:paid_invoice){ FactoryGirl.create(:invoice, pledge: not_included_pledge, status: :paid) }
          let!(:arbitration_invoice){ FactoryGirl.create(:invoice, pledge: included_pledge, status: :in_arbitration) }

          it "should only include not paid invoices" do
            # puts fundraiser.campaigns.past.eager_load(:invoices).map{|c| c.invoices.map(&:status); puts c.invoices.map(&:paid?); puts; }
            fundraiser.campaigns.with_outstanding_invoices.should == [included_campaign]
          end

          it "should not include paid invoices" do
            fundraiser.campaigns.with_outstanding_invoices.should_not include(not_included_campaign)
          end

          it "should not include a campaign with both paid and unpaid invoices" do
            not_included_invoice = FactoryGirl.create(:invoice, pledge: included_pledge, status: :paid)

            included_campaign.invoices.should include(not_paid_invoice)
            included_campaign.invoices.should include(arbitration_invoice)
            included_campaign.invoices.should include(not_included_invoice)
            fundraiser.campaigns.with_outstanding_invoices.should_not include(included_campaign)
          end
        end
      end
    end

  end
end
