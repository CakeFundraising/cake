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
  
  it { should have_many(:received_payments).dependent(:destroy) }

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

          it "should include paid and not paid invoices" do
            fundraiser.campaigns.with_outstanding_invoices.should == [included_campaign]
          end

          it "should not include only paid invoices" do
            fundraiser.campaigns.with_outstanding_invoices.should_not include(not_included_campaign)
          end

          # it "should not include a campaign with both paid and unpaid invoices" do
          #   not_included_invoice = FactoryGirl.create(:invoice, pledge: included_pledge, status: :paid)

          #   included_campaign.invoices.should include(not_paid_invoice)
          #   included_campaign.invoices.should include(arbitration_invoice)
          #   included_campaign.invoices.should include(not_included_invoice)
          #   fundraiser.campaigns.with_outstanding_invoices.should_not include(included_campaign)
          # end
        end
      end
    end

  end

  context 'Analytics' do
    let!(:fundraiser){ FactoryGirl.create(:fundraiser) }

    context 'Public profile' do
      describe "Total Raised" do
        before(:each) do
          @campaigns = create_list(:campaign, 3, fundraiser: fundraiser) 
          @invoices = create_list(:invoice, 5, campaign: @campaigns.sample)
          @pending_invoices = create_list(:pending_invoice, 5, campaign: @campaigns.sample)
        end

        it "should show total dollars collected by all FR paid campaigns's invoices" do
          total = @invoices.map(&:due_cents).sum
          expect( fundraiser.total_raised ).to eql(total)
        end

        it "should not include dollars coming from pending invoices" do
          total = @pending_invoices.map(&:due_cents).sum
          expect( fundraiser.total_raised ).not_to eql(total)
        end
      end

      describe "Rank" do
        #should return the position of the FR in the set of FRs ordered by descendent paid invoice's due_cents

        before(:each) do
          @fundraisers = create_list(:fundraiser, 5)

          @fundraisers.each do |fr|
            campaign = FactoryGirl.create(:campaign, fundraiser: fr)
            FactoryGirl.create(:invoice, campaign: campaign)
          end
        end

        it 'should return 1 when FR has the greatest paid due' do
          campaign = FactoryGirl.create(:campaign, fundraiser: fundraiser)
          FactoryGirl.create(:invoice, campaign: campaign, due_cents: rand(999999999))

          expect( fundraiser.rank ).to eql(1)
        end

        it "should return 2 when FR has the second greatest paid due" do
          campaign = FactoryGirl.create(:campaign, fundraiser: fundraiser)
          invoice = FactoryGirl.create(:invoice, campaign: campaign, due_cents: rand(99999999))

          other_campaign = FactoryGirl.create(:campaign, fundraiser: @fundraisers.last)
          FactoryGirl.create(:invoice, campaign: other_campaign, due_cents: invoice.due_cents + 10 )

          expect( fundraiser.rank ).to eql(2)
        end

        it "should return the position of the FR in the set of FR's ordered by descendent paid invoice's due_cents" do
          campaign = FactoryGirl.create(:campaign, fundraiser: fundraiser)
          FactoryGirl.create(:invoice, campaign: campaign, due_cents: 1000)

          expect( fundraiser.rank ).to eql(6)
        end
      end

      describe 'Local Rank' do
        #should return the position of the FR in the set of same zip code FRs ordered by descendent paid invoice's due_cents

        before(:each) do
          @fundraisers = create_list(:fundraiser, 5)

          @fundraisers.each do |fr|
            fr.location.update_attribute(:zip_code, fundraiser.location.zip_code) #same zip code
            
            campaign = FactoryGirl.create(:campaign, fundraiser: fr)
            FactoryGirl.create(:invoice, campaign: campaign)
          end
        end

        it 'should return 1 when FR has the greatest paid due' do
          campaign = FactoryGirl.create(:campaign, fundraiser: fundraiser)
          FactoryGirl.create(:invoice, campaign: campaign, due_cents: rand(999999999))

          expect( fundraiser.local_rank ).to eql(1)
        end

        it "should return 2 when FR has the second greatest paid due" do
          campaign = FactoryGirl.create(:campaign, fundraiser: fundraiser)
          invoice = FactoryGirl.create(:invoice, campaign: campaign, due_cents: rand(99999999))

          other_campaign = FactoryGirl.create(:campaign, fundraiser: @fundraisers.last)
          FactoryGirl.create(:invoice, campaign: other_campaign, due_cents: invoice.due_cents + 10 )

          expect( fundraiser.local_rank ).to eql(2)
        end

        it "should return the position of the FR in the set of FR's ordered by descendent paid invoice's due_cents" do
          campaign = FactoryGirl.create(:campaign, fundraiser: fundraiser)
          FactoryGirl.create(:invoice, campaign: campaign, due_cents: 1000)

          expect( fundraiser.local_rank ).to eql(6)
        end
      end

      describe "Number of Campaigns" do
        it "should return the number of campaigns created by FR" do
          @campaigns = create_list(:campaign, 15, fundraiser: fundraiser)

          expect( fundraiser.campaigns_count ).to eql(15)
        end
      end

      describe "Average Pledge" do
        before(:each) do
          @pending_pledges = create_list(:pending_pledge, 2, fundraiser: fundraiser)
          @rejected_pledges = create_list(:rejected_pledge, 3, fundraiser: fundraiser)
          @accepted_pledges = create_list(:pledge, 4, fundraiser: fundraiser)
          @past_pledges = create_list(:past_pledge, 5, fundraiser: fundraiser)
        end

        it "should be the sum of all pledges/number of pledges" do
          pledges = @accepted_pledges + @past_pledges
          avg = pledges.map(&:total_amount_cents).sum/pledges.count
          expect( fundraiser.average_pledge ).to eql(avg)
        end
      end

      describe "Average Donation" do
        before(:each) do
          campaigns = create_list(:campaign, 5, fundraiser: fundraiser)

          @paid_invoices = create_list(:invoice, 12, campaign: campaigns.sample)
          @pending_invoices = create_list(:pending_invoice, 12, campaign: campaigns.sample)
        end

        it "should be the average of SP's paid invoices" do
          avg = @paid_invoices.map(&:due_cents).sum/@paid_invoices.count
          expect( fundraiser.average_donation ).to eql(avg)
        end

        it "should not be the average of SP's pending invoices" do
          avg = @pending_invoices.map(&:due_cents).sum/@pending_invoices.count
          expect( fundraiser.average_donation ).not_to eql(avg)
        end
      end

      describe "Average Donation per Click" do
        before(:each) do
          @pending_pledges = create_list(:pending_pledge, 2, fundraiser: fundraiser)
          @rejected_pledges = create_list(:rejected_pledge, 3, fundraiser: fundraiser)
          @accepted_pledges = create_list(:pledge, 4, fundraiser: fundraiser)
          @past_pledges = create_list(:past_pledge, 5, fundraiser: fundraiser)
        end

        it "should be the average of accepted and past pledges's amount_per_click" do
          pledges = @accepted_pledges + @past_pledges
          avg = pledges.map(&:amount_per_click_cents).sum/pledges.count
          expect( fundraiser.average_donation_per_click ).to eql(avg)
        end
      end

      describe "Average Sponsors per Campaign" do
        before(:each) do
          @campaigns = create_list(:campaign, 5, fundraiser: fundraiser)

          @pending_pledges = []
          @rejected_pledges = []
          @accepted_pledges = []
          @past_pledges = []

          @campaigns.each do |c|
            @pending_pledges << create_list(:pending_pledge, 2, campaign: c)
            @rejected_pledges << create_list(:rejected_pledge, 3, campaign: c)
            @accepted_pledges << create_list(:pledge, 4, campaign: c)
            @past_pledges << create_list(:past_pledge, 5, campaign: c)
          end

          fundraiser.campaigns.reload
        end

        it "should show total number of sponsors for all campaigns/no of campaigns" do
          sponsors = (@accepted_pledges.flatten + @past_pledges.flatten).map(&:sponsor)
          avg = sponsors.count.to_f/@campaigns.count.to_f
          expect( fundraiser.average_sponsors_per_campaign ).to eql(avg)
        end

        it "should not include sponsors form pending pledges" do
          sponsors = @pending_pledges.flatten.map(&:sponsor)
          avg = sponsors.count.to_f/@campaigns.count.to_f
          expect( fundraiser.average_sponsors_per_campaign ).not_to eql(avg)
        end

        it "should not include sponsors form rejected pledges" do
          sponsors = @rejected_pledges.flatten.map(&:sponsor)
          avg = sponsors.count.to_f/@campaigns.count.to_f
          expect( fundraiser.average_sponsors_per_campaign ).not_to eql(avg)
        end
      end

      describe "Average Clicks per Pledge" do
        before(:each) do
          @accepted_pledges = create_list(:pledge, 4, fundraiser: fundraiser, clicks_count: 0)
          @past_pledges = create_list(:past_pledge, 5, fundraiser: fundraiser, clicks_count: 0)
          @pledges = @accepted_pledges + @past_pledges

          @pledges.each do |p|
            create_list(:click, 5, pledge: p)
          end           
        end

        it "should be the total clicks divided total of accepted and past pledges" do
          avg = @pledges.map(&:clicks).flatten.count/@pledges.count
          expect( fundraiser.average_clicks_per_pledge ).to eql(avg)
        end
      end

      describe "Top Causes" do
        before(:each) do
          @accepted_pledges = create_list(:pledge, 4, fundraiser: fundraiser)   
        end

        it "should return a hash" do
          expect( fundraiser.top_causes ).to be_instance_of(Hash)
        end

        it "should list the top 3 causes" do
          expect( fundraiser.top_causes.keys.count ).to eql(3)
        end

        it "should list the causes from SP's top 3 pledges" do
          @pledges = @accepted_pledges.sort_by{|p| [p.total_amount, p.amount_per_click] }
          expect( fundraiser.top_causes.keys ).to eql(@pledges.first(3).map(&:main_cause).uniq)
        end

        it "should list the total_amount from SP's top 3 pledges" do
          @pledges = @accepted_pledges.sort_by{|p| [p.total_amount, p.amount_per_click] }
          expect( fundraiser.top_causes.values ).to eql(@pledges.first(3).uniq(&:main_cause).map(&:total_amount))
        end
      end

    end
  end

end
