require 'rails_helper'

describe Fundraiser do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:phone) }

  it "should validate other attributes when editing" do
    allow(subject).to receive(:new_record?) { false }
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

  it { should have_many(:direct_donations).dependent(:destroy) }
  it { should have_many(:received_payments).dependent(:destroy) }

  it { should accept_nested_attributes_for(:location).update_only(true) }
  it { should accept_nested_attributes_for(:picture).update_only(true) }

  it "should validate presence of causes" do
    fundraiser = FactoryGirl.build(:fundraiser, causes: [])
    expect{fundraiser.valid?}.to change{fundraiser.errors[:causes]}.to include("can't be blank")
  end

  it "should build a picture if new object" do
    new_fundraiser = FactoryGirl.build(:fundraiser)
    expect(new_fundraiser.picture).to_not be_nil
    expect(new_fundraiser.picture).to be_instance_of(Picture)
  end

  it "should build a location if new object" do
    new_fundraiser = FactoryGirl.build(:fundraiser)
    expect(new_fundraiser.location).to_not be_nil
    expect(new_fundraiser.location).to be_instance_of(Location)
  end

  context 'Association methods' do
    let!(:fundraiser){ FactoryGirl.create(:fundraiser) }

    describe "Pledges" do
      let!(:campaigns){ create_list(:campaign, 5, fundraiser: fundraiser) }
      
      it "should show a collection of fundraiser's accepted pledges" do
        accepted_pledges = create_list(:pledge, 10, campaign: campaigns.sample)
        expect(fundraiser.pledges.accepted.reload).to eq accepted_pledges
      end

      it "should show a collection of fundraiser's pending pledges" do
        pending_pledges = create_list(:pending_pledge, 10, campaign: campaigns.sample)
        expect(fundraiser.pledges.pending.reload).to eq pending_pledges
      end

      it "should show a collection of fundraiser's rejected pledges" do
        rejected_pledges = create_list(:rejected_pledge, 10, campaign: campaigns.sample)
        expect(fundraiser.pledges.rejected.reload).to eq rejected_pledges
      end
    end

    describe "Sponsors" do
      let!(:campaigns){ create_list(:campaign, 5, fundraiser: fundraiser) }

      # Sponsors are the sponsors of FR's accepted pledges
      it "should show a collection of fundraiser's sponsors" do
        accepted_pledges = create_list(:pledge, 10, campaign: campaigns.sample)
        pending_pledges  = create_list(:pending_pledge, 10, campaign: campaigns.sample)
        rejected_pledges = create_list(:rejected_pledge, 10, campaign: campaigns.sample)

        expect(fundraiser.sponsors.sort).to eq accepted_pledges.map(&:sponsor).uniq.sort
        expect(fundraiser.sponsors.sort).to_not include(pending_pledges.map(&:sponsor).uniq.sort)
        expect(fundraiser.sponsors.sort).to_not include(rejected_pledges.map(&:sponsor).uniq.sort)
      end
    end

    context 'Campaigns' do
      let!(:included_campaign){ FactoryGirl.create(:past_campaign, fundraiser: fundraiser) }
      let!(:not_included_campaign){ FactoryGirl.create(:past_campaign, fundraiser: fundraiser) }

      let!(:included_pledge){ FactoryGirl.create(:pledge, campaign: included_campaign) }
      let!(:not_included_pledge){ FactoryGirl.create(:pledge, campaign: not_included_campaign) }

      describe "with_paid_invoices" do
        it "should not return any campaign if there isn't invoices created" do
          expect(fundraiser.campaigns.with_paid_invoices).to be_empty
        end
        
        context 'invoices present' do
          let!(:paid_invoice){ FactoryGirl.create(:invoice, pledge: included_pledge, status: :paid) }
          let!(:not_paid_invoice){ FactoryGirl.create(:invoice, pledge: not_included_pledge, status: :due_to_pay) }

          it "should not include campaigns with unpaid invoices" do
            expect(fundraiser.campaigns.with_paid_invoices).to_not include(not_included_campaign)
          end

          it "should include only campaigns with paid invoices" do
            expect(fundraiser.campaigns.with_paid_invoices).to eq [included_campaign]
          end

          context 'should not include a campaign with both paid and unpaid invoices' do
            it "when invoices is due to pay" do
              not_included_invoice = FactoryGirl.create(:invoice, pledge: included_pledge, status: :due_to_pay)

              expect(included_campaign.invoices).to include(paid_invoice)
              expect(included_campaign.invoices).to include(not_included_invoice)
              expect(fundraiser.campaigns.with_paid_invoices).to_not include(included_campaign)
            end

            it "when invoices is in arbitration" do
              not_included_invoice = FactoryGirl.create(:invoice, pledge: included_pledge, status: :in_arbitration)

              expect(included_campaign.invoices).to include(paid_invoice)
              expect(included_campaign.invoices).to include(not_included_invoice)
              expect(fundraiser.campaigns.with_paid_invoices).to_not include(included_campaign)
            end
          end
        end
      end

      describe "with_outstanding_invoices" do
        it "should not return any campaign if there isn't invoices" do
          expect(fundraiser.campaigns.with_outstanding_invoices).to be_empty
        end

        context 'invoices present' do
          let!(:not_paid_invoice){ FactoryGirl.create(:invoice, pledge: included_pledge, status: :due_to_pay) }
          let!(:paid_invoice){ FactoryGirl.create(:invoice, pledge: not_included_pledge, status: :paid) }
          let!(:arbitration_invoice){ FactoryGirl.create(:invoice, pledge: included_pledge, status: :in_arbitration) }

          it "should include paid and not paid invoices" do
            expect(fundraiser.campaigns.with_outstanding_invoices).to eq [included_campaign]
          end

          it "should not include only paid invoices" do
            expect(fundraiser.campaigns.with_outstanding_invoices).to_not include(not_included_campaign)
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

    context 'related to particular SP (tables)' do
      before(:each) do
        @sponsor = FactoryGirl.create(:sponsor)  
      end

      describe "Average Donation" do
        before(:each) do
          campaigns = create_list(:campaign, 3, fundraiser: fundraiser)

          @pledges = create_list(:past_pledge, 5, sponsor: @sponsor, campaign: campaigns.sample)

          @paid_invoices = []
          @pending_invoices = []

          @pledges.each do |pledge|
            @paid_invoices << create_list(:invoice, 2, pledge: pledge)
            @pending_invoices << create_list(:pending_invoice, 2, pledge: pledge)
          end

          @paid_invoices = @paid_invoices.flatten
          @pending_invoices = @pending_invoices.flatten
        end

        it "should be the average of SP's paid invoices" do
          avg = @paid_invoices.map(&:due_cents).sum/@paid_invoices.count
          expect( fundraiser.average_donation_with(@sponsor) ).to eql(avg)
        end

        it "should not be the average of SP's pending invoices" do
          avg = @pending_invoices.map(&:due_cents).sum/@pending_invoices.count
          expect( fundraiser.average_donation_with(@sponsor) ).not_to eql(avg)
        end
      end

      describe "Average Pledge" do
        before(:each) do
          campaigns = create_list(:campaign, 3, fundraiser: fundraiser)

          @pending_pledges = create_list(:pending_pledge, 2, sponsor: @sponsor, campaign: campaigns.sample)
          @rejected_pledges = create_list(:rejected_pledge, 3, sponsor: @sponsor, campaign: campaigns.sample)
          @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor, campaign: campaigns.sample)
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor, campaign: campaigns.sample)
        end

        it "should be the average of accepted and past pledges's total_amount" do
          pledges = @accepted_pledges + @past_pledges
          avg = pledges.map(&:total_amount_cents).sum/pledges.count
          expect( fundraiser.average_pledge_with(@sponsor) ).to eql(avg)
        end
      end

      describe "Average Donation per Click" do
        before(:each) do
          campaigns = create_list(:campaign, 3, fundraiser: fundraiser)

          @pending_pledges = create_list(:pending_pledge, 2, sponsor: @sponsor, campaign: campaigns.sample)
          @rejected_pledges = create_list(:rejected_pledge, 3, sponsor: @sponsor, campaign: campaigns.sample)
          @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor, campaign: campaigns.sample)
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor, campaign: campaigns.sample)
        end



        it "should be the average of accepted and past pledges's amount_per_click" do
          pledges = @accepted_pledges + @past_pledges
          avg = pledges.map(&:amount_per_click_cents).sum/pledges.count
          expect( fundraiser.average_donation_per_click_with(@sponsor) ).to eql(avg)
        end
      end

      describe "Average Clicks per Pledge" do
        before(:each) do
          campaigns = create_list(:campaign, 3, fundraiser: fundraiser)

          @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor, campaign: campaigns.sample, clicks_count: 0)
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor, campaign: campaigns.sample, clicks_count: 0)

          @pledges = @accepted_pledges + @past_pledges

          @pledges.each do |p|
            create_list(:click, 5, pledge: p)
            p.update_attribute(:clicks_count, 5)
          end
        end

        it "should be the total clicks divided total of accepted and past pledges" do
          avg = @pledges.map(&:clicks).flatten.count/@pledges.count
          expect( fundraiser.average_clicks_per_pledge_with(@sponsor) ).to eql(avg)
        end
      end

      context 'Impressions' do
        before(:each) do
          campaigns = create_list(:campaign, 5, fundraiser: fundraiser)

          @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor, campaign: campaigns.sample, clicks_count: 0)
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor, campaign: campaigns.sample, clicks_count: 0)
          @pending_pledges = create_list(:pending_pledge, 3, sponsor: @sponsor, campaign: campaigns.sample, clicks_count: 0)

          @pledges = @accepted_pledges + @past_pledges

          @impressions = create_list(:impression, 25, impressionable: @accepted_pledges.sample)
          @pending_impressions = create_list(:impression, 15, impressionable: @pending_pledges.sample)
          @past_impressions = create_list(:impression, 56, impressionable: @past_pledges.sample)

          @impressions_count = @impressions.count + @past_impressions.count
        end

        describe "Pledge Views" do
          it "should be the sum of all accepted and past pledge impressions between that SP and FR" do
            expect( fundraiser.pledge_views_with(@sponsor) ).to eql(@impressions_count)
          end

          it "should not include impressions from pending pledges" do
            expect( fundraiser.pledge_views_with(@sponsor) ).not_to eql(@pending_impressions.count)
          end
        end
        
        describe "Average Pledge Views" do
          it "should be total impressions of valid pledges between SP and FR divided that count" do
            avg = (@impressions_count/@pledges.count).floor
            expect( fundraiser.average_pledge_views_with(@sponsor) ).to eql(avg)
          end

          it "should not include impressions from pending pledges" do
            avg = (@pending_impressions.count/@pending_pledges.count).floor
            expect( fundraiser.average_pledge_views_with(@sponsor) ).not_to eql(avg)
          end
        end

        describe "Average Engagement" do
          before(:each) do
            accepted = @accepted_pledges.sample
            past = @past_pledges.sample
            pending = @pending_pledges.sample

            @clicks = create_list(:click, 5, pledge: accepted)
            accepted.update_attribute(:clicks_count, 5)
            
            @past_clicks = create_list(:click, 5, pledge: past)  
            past.update_attribute(:clicks_count, 5)

            @pending_clicks = create_list(:click, 5, pledge: pending) 
            pending.update_attribute(:clicks_count, 5)

            @total_clicks = @clicks.count + @past_clicks.count 
          end

          it "should be the sum of all clicks divided accepted and past pledges count" do
            avg = (@total_clicks.to_f/@impressions_count.to_f)
            expect( fundraiser.average_engagement_with(@sponsor) ).to eql(avg)
          end

          it "should not include clicks from pending pledges" do
            avg = (@pending_clicks.count.to_f/@pending_impressions.count.to_f)
            expect( fundraiser.average_engagement_with(@sponsor) ).not_to eql(avg)
          end
        end
      end

    end

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
          FactoryGirl.create(:invoice, campaign: campaign, due_cents: 10)

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
          FactoryGirl.create(:invoice, campaign: campaign, due_cents: 100)

          expect( fundraiser.local_rank ).to eql(6)
        end
      end

      describe "Number of Campaigns" do
        it "should return the number of campaigns created by FR" do
          fundraiser.campaigns.destroy_all
          @campaigns = create_list(:campaign, 15, fundraiser: fundraiser)

          expect( fundraiser.campaigns_count ).to eql(15)
        end
      end

      describe "Average Pledge" do
        before(:each) do
          campaigns = create_list(:campaign, 3, fundraiser: fundraiser)

          @pending_pledges = create_list(:pending_pledge, 2, campaign: campaigns.sample)
          @rejected_pledges = create_list(:rejected_pledge, 3, campaign: campaigns.sample)
          @accepted_pledges = create_list(:pledge, 4, campaign: campaigns.sample)
          @past_pledges = create_list(:past_pledge, 5, campaign: campaigns.sample)
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
          campaigns = create_list(:campaign, 5, fundraiser: fundraiser)

          @pending_pledges = create_list(:pending_pledge, 2, campaign: campaigns.sample)
          @rejected_pledges = create_list(:rejected_pledge, 3, campaign: campaigns.sample)
          @accepted_pledges = create_list(:pledge, 4, campaign: campaigns.sample)
          @past_pledges = create_list(:past_pledge, 5, campaign: campaigns.sample)
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
          campaigns = create_list(:campaign, 5, fundraiser: fundraiser)

          @accepted_pledges = create_list(:pledge, 4, campaign: campaigns.sample, clicks_count: 0)
          @past_pledges = create_list(:past_pledge, 5, campaign: campaigns.sample, clicks_count: 0)
          @pledges = @accepted_pledges + @past_pledges

          @pledges.each do |p|
            create_list(:click, 5, pledge: p)
            p.update_attribute(:clicks_count, 5)
          end           
        end

        it "should be the total clicks divided total of accepted and past pledges" do
          avg = @pledges.map(&:clicks).flatten.count/@pledges.count
          expect( fundraiser.average_clicks_per_pledge ).to eql(avg)
        end
      end

      context 'Impressions' do
        before(:each) do
          @launched_campaigns = create_list(:campaign, 5, fundraiser: fundraiser)
          @pending_campaigns = create_list(:pending_campaign, 5, fundraiser: fundraiser)
          @past_campaigns = create_list(:past_campaign, 5, fundraiser: fundraiser)

          @impressions = create_list(:impression, 25, impressionable: @launched_campaigns.sample)
          @pending_impressions = create_list(:impression, 15, impressionable: @pending_campaigns.sample)
          @past_impressions = create_list(:impression, 56, impressionable: @past_campaigns.sample)

          @impressions_count = @impressions.count + @past_impressions.count
        end

        describe "Campaign Views" do
          it "should count all launched and past campaign impressions" do
            expect( fundraiser.campaign_views ).to eql(@impressions_count)
          end

          it "should not include pending campaign impressions" do
            expect( fundraiser.campaign_views ).not_to eql(@pending_impressions.count)
          end
        end
        
        describe "Average Campaign Views" do
          it "should be sum of all launched and past campaign impressions divided launched and past campaigns count" do
            campaigns_count = @launched_campaigns.count + @past_campaigns.count
            avg = (@impressions_count/campaigns_count).floor

            expect( fundraiser.average_campaign_views ).to eql(avg)
          end

          it "should not include pending campaigns" do
            avg = (@pending_impressions.count/@pending_campaigns.count).floor
            expect( fundraiser.average_campaign_views ).not_to eql(avg)
          end
        end

        describe "Average Engagement" do
          before(:each) do
            @pledges = create_list(:pledge, 15, clicks_count: 0, campaign: @launched_campaigns.sample)
            @past_pledges = create_list(:past_pledge, 55, clicks_count: 0, campaign: @past_campaigns.sample)
            @pending_pledges = create_list(:pending_pledge, 44, clicks_count: 0, campaign: @pending_campaigns.sample)

            accepted = @pledges.sample
            past = @past_pledges.sample
            pending = @pending_pledges.sample

            @clicks = create_list(:click, 9, pledge: accepted)
            accepted.update_attribute(:clicks_count, 9)
            
            @past_clicks = create_list(:click, 6, pledge: past)  
            past.update_attribute(:clicks_count, 6)

            @pending_clicks = create_list(:click, 3, pledge: pending) 
            pending.update_attribute(:clicks_count, 3)

            @total_clicks = @clicks.count + @past_clicks.count 
          end

          it "should be total_clicks divided by total launched and past campaign impressions" do
            avg = (@total_clicks.to_f/@impressions_count.to_f)
            expect( fundraiser.average_engagement ).to eql(avg)
          end

          it "should not include clicks from pending pledges" do
            avg = (@pending_clicks.count.to_f/@pending_impressions.count.to_f)
            expect( fundraiser.average_engagement ).not_to eql(avg)
          end
        end
        
      end

      describe "Top Causes" do
        before(:each) do
          campaigns = create_list(:campaign, 3, fundraiser: fundraiser)

          @accepted_pledges = []
          campaigns.each do |campaign|
            @accepted_pledges << create_list(:pledge, 4, campaign: campaign)
          end
        end

        it "should return a hash" do
          expect( fundraiser.top_causes ).to be_instance_of(Hash)
        end

        it "should list the top 3 causes" do
          expect( fundraiser.top_causes.keys.count ).to eql(3)
        end

        it "should list the causes from SP's top 3 pledges" do
          @pledges = @accepted_pledges.flatten.sort_by{|p| [p.total_amount_cents, p.amount_per_click_cents] }

          expect( fundraiser.top_causes.keys.sort ).to eql(@pledges.map(&:main_cause).uniq.first(3).sort)
        end

        it "should list the total_amount from SP's top 3 pledges" do
          @pledges = @accepted_pledges.flatten.sort_by{|p| [p.total_amount_cents, p.amount_per_click_cents] }
          expect( fundraiser.top_causes.values.sort ).to eql(@pledges.uniq(&:main_cause).map(&:total_amount).first(3).sort)
        end
      end

    end

    context 'FR Home Dashboard' do
      describe "Active Campaign Donations" do
        before(:each) do
          campaigns = create_list(:campaign, 3, fundraiser: fundraiser)

          @pending_pledges = create_list(:pending_pledge, 2, campaign: campaigns.sample)
          @rejected_pledges = create_list(:rejected_pledge, 3, campaign: campaigns.sample)
          @accepted_pledges = create_list(:pledge, 4, campaign: campaigns.sample)
          @past_pledges = create_list(:past_pledge, 5, campaign: campaigns.sample)
        end

        it "should show sum of clicks_count*amount_per_click for all active pledges" do
          donation = @accepted_pledges.map(&:total_charge).sum
          expect( fundraiser.active_campaigns_donation ).to eql(donation)
        end

        it "should not consider the pending pledges" do
          donation = @pending_pledges.map(&:total_charge).sum
          expect( fundraiser.active_campaigns_donation ).not_to eql(donation)
        end

        it "should not consider the rejected pledges" do
          donation = @rejected_pledges.map(&:total_charge).sum
          expect( fundraiser.active_campaigns_donation ).not_to eql(donation)
        end

        it "should not consider the past pledges" do
          donation = @past_pledges.map(&:total_charge).sum
          expect( fundraiser.active_campaigns_donation ).not_to eql(donation)
        end
      end

      describe "Average Clicks per Campaign" do
        before(:each) do
          campaigns = create_list(:campaign, 3, fundraiser: fundraiser)

          @accepted_pledges = create_list(:pledge, 4, campaign: campaigns.sample, clicks_count: 0)
          @past_pledges = create_list(:past_pledge, 5, campaign: campaigns.sample, clicks_count: 0)
          @pledges = @accepted_pledges + @past_pledges

          @pledges.each do |p|
            create_list(:click, 5, pledge: p)
            p.update_attribute(:clicks_count, 5)
          end           
        end

        it "should be the total clicks divided total of accepted and past pledges" do
          avg = @pledges.map(&:clicks).flatten.count/@pledges.count
          expect( fundraiser.average_clicks_per_pledge ).to eql(avg)
        end
      end

      describe "Outstanding Invoices" do
        before(:each) do
          fundraiser.invoices.destroy_all

          campaigns = create_list(:campaign, 3, fundraiser: fundraiser)

          @past_pledges = create_list(:past_pledge, 5, campaign: campaigns.sample)

          @paid_invoices = []
          @outstanding_invoices = []

          @past_pledges.each do |pledge|
            @paid_invoices << create_list(:invoice, 3, pledge: pledge)
            @outstanding_invoices << create_list(:pending_invoice, 5, pledge: pledge)
          end
        end

        it "should show total dollar amount of outstanding invoices" do
          due = @outstanding_invoices.flatten.map(&:due_cents).sum
          expect( fundraiser.invoices_due ).to eql(due)
        end

        it "should not include amounts from paid invoices" do
          due = @paid_invoices.flatten.map(&:due_cents).sum
          expect( fundraiser.invoices_due ).not_to eql(due)
        end
      end
    end

  end

end
