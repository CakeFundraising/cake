require 'rails_helper'

describe Sponsor do
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
    should validate_presence_of(:customer_demographics) 
  end

  it { should belong_to(:manager).class_name('User') }
  it { should have_one(:location).dependent(:destroy) }
  it { should have_one(:picture).dependent(:destroy) }
  it { should have_one(:stripe_account).dependent(:destroy) }
  it { should have_many(:users) }
  it { should have_many(:pledge_requests).dependent(:destroy) }
  it { should have_many(:pledges).dependent(:destroy) }
  it { should have_many(:campaigns).through(:pledges) }
  it { should have_many(:invoices).through(:pledges) }

  it { should have_many(:payments).dependent(:destroy) }

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
    expect(new_sponsor.picture).to_not be_nil
    expect(new_sponsor.picture).to be_instance_of(Picture)
  end

  it "should build a location if new object" do
    new_sponsor = FactoryGirl.build(:sponsor)
    expect(new_sponsor.location).to_not be_nil
    expect(new_sponsor.location).to be_instance_of(Location)
  end

  context 'Association methods' do
    before(:each) do
      @sponsor = FactoryGirl.create(:sponsor)
    end

    describe "Pledges" do
      it "should show a collection of sponsor's active pledges" do
        active_pledges = create_list(:pledge, 10, sponsor: @sponsor)
        expect(@sponsor.pledges.active.reload.sort).to eq active_pledges.sort
      end

      it "should show a collection of sponsor's pending pledges" do
        pending_pledges = create_list(:pending_pledge, 10, sponsor: @sponsor)
        expect(@sponsor.pledges.pending.reload.sort).to eq pending_pledges.sort
      end

      it "should show a collection of sponsor's rejected pledges" do
        rejected_pledges = create_list(:rejected_pledge, 10, sponsor: @sponsor)
        expect(@sponsor.pledges.rejected.reload.sort).to eq rejected_pledges.sort
      end
    end

    describe "Fundraisers" do
      # Fundraisers are the FR of the pledges's campaigns
      it "should show a collection of sponsor's fundraisers" do
        accepted_pledges = create_list(:pledge, 10, sponsor: @sponsor)
        pending_pledges = create_list(:pending_pledge, 10, sponsor: @sponsor)
        rejected_pledges = create_list(:rejected_pledge, 10, sponsor: @sponsor)

        expect(@sponsor.fundraisers).to eq accepted_pledges.map(&:fundraiser).uniq
        expect(@sponsor.fundraisers).to_not include(pending_pledges.map(&:fundraiser))
        expect(@sponsor.fundraisers).to_not include(rejected_pledges.map(&:fundraiser))
      end
    end

    context 'Invoices' do
      describe "#outstanding_invoices" do
        before(:each) do
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor)
          @past_pledges.each do |pledge|
            create_list(:invoice, 3, pledge: pledge)
            create_list(:pending_invoice, 3, pledge: pledge)
          end
        end

        it "should not include paid invoices" do
          @sponsor.outstanding_invoices.each do |invoice|
            expect(invoice.status).to_not eq 'paid'
          end
        end

        it "should list invoices of past accepted pledges" do
          @sponsor.outstanding_invoices.each do |invoice|
            expect(invoice.pledge).to be_past
            expect(invoice.pledge).to_not be_active
          end
        end
      end

      describe "#past_invoices" do
        before(:each) do
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor)
          @past_pledges.each do |pledge|
            create_list(:invoice, 3, pledge: pledge)
            create_list(:pending_invoice, 3, pledge: pledge)
          end
        end

        it "should include only paid invoices" do
          @sponsor.past_invoices.each do |invoice|
            expect(invoice.status).to eq 'paid'
          end
        end

        it "should list invoices of past accepted pledges" do
          @sponsor.past_invoices.each do |invoice|
            expect(invoice.pledge).to be_past
            expect(invoice.pledge).to_not be_active
          end
        end
      end
    end

  end

  context 'Analytics' do
    before(:each) do
      @sponsor = FactoryGirl.create(:sponsor)
    end

    context 'related to particular FR (tables)' do
      before(:each) do
        @fundraiser = FactoryGirl.create(:fundraiser)  
      end

      describe "Average Donation" do
        before(:each) do
          @campaigns = create_list(:campaign, 5, fundraiser: @fundraiser)

          @campaigns.each do |campaign|
            @pledges = create_list(:past_pledge, 1, sponsor: @sponsor, campaign: campaign)
          end

          @paid_invoices = []
          @pending_invoices = []

          @pledges.each do |pledge|
            @paid_invoices << create_list(:invoice, 2, pledge: pledge, sponsor: @sponsor)
            @pending_invoices << create_list(:pending_invoice, 2, pledge: pledge, sponsor: @sponsor)
          end

          @paid_invoices = @paid_invoices.flatten
          @pending_invoices = @pending_invoices.flatten
        end

        it "should be the average of SP's paid invoices to that FR" do
          avg = @paid_invoices.map(&:due_cents).sum/@paid_invoices.count
          expect( @sponsor.average_donation_with(@fundraiser) ).to eql(avg)
        end

        it "should not be the average of SP's pending invoices to that FR" do
          avg = @pending_invoices.map(&:due_cents).sum/@pending_invoices.count
          expect( @sponsor.average_donation_with(@fundraiser) ).not_to eql(avg)
        end
      end

      describe "Average Pledge" do
        before(:each) do
          @campaigns = create_list(:campaign, 5, fundraiser: @fundraiser)

          @campaigns.each do |campaign|
            @pending_pledges = create_list(:pending_pledge, 2, sponsor: @sponsor, campaign: campaign)
            @rejected_pledges = create_list(:rejected_pledge, 3, sponsor: @sponsor, campaign: campaign)
            @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor, campaign: campaign)
            @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor, campaign: campaign)
          end
        end

        it "should be the average of accepted and past pledges's total_amount" do
          pledges = @accepted_pledges + @past_pledges
          avg = pledges.map(&:total_amount_cents).sum/pledges.count
          expect( @sponsor.average_pledge_with(@fundraiser) ).to eql(avg)
        end
      end

      describe "Average Donation per Click" do
        before(:each) do
          @campaigns = create_list(:campaign, 5, fundraiser: @fundraiser)

          @campaigns.each do |campaign|
            @pending_pledges = create_list(:pending_pledge, 2, sponsor: @sponsor, campaign: campaign)
            @rejected_pledges = create_list(:rejected_pledge, 3, sponsor: @sponsor, campaign: campaign)
            @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor, campaign: campaign)
            @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor, campaign: campaign)
          end
        end

        it "should be the average of accepted and past pledges's amount_per_click" do
          pledges = @accepted_pledges + @past_pledges
          avg = pledges.map(&:amount_per_click_cents).sum/pledges.count
          expect( @sponsor.average_donation_per_click_with(@fundraiser) ).to eql(avg)
        end
      end

      describe "Average Clicks per Pledge" do
        before(:each) do
          @campaigns = create_list(:campaign, 3, fundraiser: @fundraiser)

          @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor, campaign: @campaigns.sample, clicks_count: 0)
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor, campaign: @campaigns.sample, clicks_count: 0)
          @pledges = @accepted_pledges + @past_pledges

          @pledges.each do |p|
            create_list(:click, 5, pledge: p)
            p.update_attribute(:clicks_count, 5)
          end           
        end

        it "should be the total clicks divided total of accepted and past pledges" do
          avg = @pledges.map(&:clicks).flatten.count/@pledges.count
          expect( @sponsor.average_clicks_per_pledge_with(@fundraiser) ).to eql(avg)
        end
      end

      context 'Impressions' do
        before(:each) do
          @campaigns = create_list(:campaign, 3, fundraiser: @fundraiser)

          @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor, campaign: @campaigns.sample, clicks_count: 0)
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor, campaign: @campaigns.sample, clicks_count: 0)
          @pending_pledges = create_list(:pending_pledge, 3, sponsor: @sponsor, campaign: @campaigns.sample, clicks_count: 0)

          @pledges = @accepted_pledges + @past_pledges

          @impressions = create_list(:impression, 25, impressionable: @accepted_pledges.sample)
          @pending_impressions = create_list(:impression, 15, impressionable: @pending_pledges.sample)
          @past_impressions = create_list(:impression, 56, impressionable: @past_pledges.sample)

          @impressions_count = @impressions.count + @past_impressions.count
        end

        describe "Pledge Views" do
          it "should be the sum of all accepted and past pledge impressions between that SP and FR" do
            expect( @sponsor.pledge_views_with(@fundraiser) ).to eql(@impressions_count)
          end

          it "should not include impressions from pending pledges" do
            expect( @sponsor.pledge_views_with(@fundraiser) ).not_to eql(@pending_impressions.count)
          end
        end
        
        describe "Average Pledge Views" do
          it "should be total impressions of valid pledges between SP and FR divided that count" do
            avg = (@impressions_count/@pledges.count).floor
            expect( @sponsor.average_pledge_views_with(@fundraiser) ).to eql(avg)
          end

          it "should not include impressions from pending pledges" do
            avg = (@pending_impressions.count/@pending_pledges.count).floor
            expect( @sponsor.average_pledge_views_with(@fundraiser) ).not_to eql(avg)
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
            expect( @sponsor.average_engagement_with(@fundraiser) ).to eql(avg)
          end

          it "should not include clicks from pending pledges" do
            avg = (@pending_clicks.count.to_f/@pending_impressions.count.to_f)
            expect( @sponsor.average_engagement_with(@fundraiser) ).not_to eql(avg)
          end
        end
      end

    end

    context 'SP public profile' do
      describe 'Total Donations' do
        before(:each) do
          @paid_invoices = create_list(:invoice, 12, sponsor: @sponsor)
          @pending_invoices = create_list(:pending_invoice, 12, sponsor: @sponsor)
        end

        it "should be the sum of all donations paid by SP" do
          expect(@sponsor.total_donation).to eql(@paid_invoices.map(&:due_cents).sum)
        end

        it "should not be the sum of all pending invoices by SP" do
          expect(@sponsor.total_donation).not_to eql(@pending_invoices.map(&:due_cents).sum)
        end
      end

      describe 'Unique Clicks' do
        it "should be the sum of all clicks from accepted and past pledges to SP’s websites" do
          @accepted_pledges = create_list(:pledge, 5, sponsor: @sponsor)
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor)

          pledges = @accepted_pledges + @past_pledges

          expect(@sponsor.unique_clicks).to eql(pledges.map(&:clicks_count).sum)        
        end
      end

      describe 'Rank' do
        #should return the position of the SP in the set of SPs ordered by descendent paid invoice's due_cents

        before(:each) do
          @sponsors = create_list(:sponsor, 5)

          @sponsors.each do |sp|
            FactoryGirl.create(:invoice, sponsor: sp)
          end
        end

        it 'should return 1 when SP has the greatest paid due' do
          FactoryGirl.create(:invoice, sponsor: @sponsor, due_cents: rand(999999999))

          expect( @sponsor.rank ).to eql(1)
        end

        it "should return 2 when SP has the second greatest paid due" do
          invoice = FactoryGirl.create(:invoice, sponsor: @sponsor, due_cents: rand(99999999))
          FactoryGirl.create(:invoice, sponsor: @sponsors.last, due_cents: invoice.due_cents + 10 )

          expect( @sponsor.rank ).to eql(2)
        end

        it "should return the position of the SP in the set of SP's ordered by descendent paid invoice's due_cents" do
          FactoryGirl.create(:invoice, sponsor: @sponsor, due_cents: 10)

          expect( @sponsor.rank ).to eql(6)
        end
      end

      describe 'Local Rank' do
        #should return the position of the SP in the set of same zip code SPs ordered by descendent paid invoice's due_cents

        before(:each) do
          @sponsors = create_list(:sponsor, 5)

          @sponsors.each do |sp|
            sp.location.update_attribute(:zip_code, @sponsor.location.zip_code) #same zip code
            FactoryGirl.create(:invoice, sponsor: sp)
          end
        end

        it 'should return 1 when SP has the greatest paid due' do
          FactoryGirl.create(:invoice, sponsor: @sponsor, due_cents: rand(999999999))

          expect( @sponsor.local_rank ).to eql(1)
        end

        it "should return 2 when SP has the second greatest paid due" do
          invoice = FactoryGirl.create(:invoice, sponsor: @sponsor, due_cents: rand(99999999))
          FactoryGirl.create(:invoice, sponsor: @sponsors.last, due_cents: invoice.due_cents + 10 )

          expect( @sponsor.local_rank ).to eql(2)
        end

        it "should return the position of the SP in the set of same zip code SPs ordered by descendent paid invoice's due_cents" do
          FactoryGirl.create(:invoice, sponsor: @sponsor, due_cents: 10)

          expect( @sponsor.local_rank ).to eql(6)
        end
      end

      describe "Number of Pledges" do
        before(:each) do
          @pending_pledges = create_list(:pending_pledge, 2, sponsor: @sponsor)
          @rejected_pledges = create_list(:rejected_pledge, 3, sponsor: @sponsor)
          @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor)
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor)           
        end

        it "should return the number of accepted or past pledges of the SP" do
          expect( @sponsor.pledges_count ).to eql(9) # accepted + past
        end

        it "should not include pending pledges" do
          expect( @sponsor.pledges_count ).not_to eql(6) # accepted + pending
          expect( @sponsor.pledges_count ).not_to eql(7) # past + pending
          expect( @sponsor.pledges_count ).not_to eql(11) # past + accepted + pending
        end

        it "should not include past pledges" do
          expect( @sponsor.pledges_count ).not_to eql(7) # accepted + past
          expect( @sponsor.pledges_count ).not_to eql(8) # past + past
          expect( @sponsor.pledges_count ).not_to eql(12) # past + accepted + past
        end
      end

      describe "Average Pledge" do
        before(:each) do
          @pending_pledges = create_list(:pending_pledge, 2, sponsor: @sponsor)
          @rejected_pledges = create_list(:rejected_pledge, 3, sponsor: @sponsor)
          @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor)
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor)           
        end

        it "should be the average of accepted and past pledges's total_amount" do
          pledges = @accepted_pledges + @past_pledges
          avg = pledges.map(&:total_amount_cents).sum/pledges.count
          expect( @sponsor.average_pledge ).to eql(avg)
        end
      end

      describe "Average Donation" do
        before(:each) do
          @paid_invoices = create_list(:invoice, 12, sponsor: @sponsor)
          @pending_invoices = create_list(:pending_invoice, 12, sponsor: @sponsor)
        end

        it "should be the average of SP's paid invoices" do
          avg = @paid_invoices.map(&:due_cents).sum/@paid_invoices.count
          expect( @sponsor.average_donation ).to eql(avg)
        end

        it "should not be the average of SP's pending invoices" do
          avg = @pending_invoices.map(&:due_cents).sum/@pending_invoices.count
          expect( @sponsor.average_donation ).not_to eql(avg)
        end
      end

      describe "Average Donation per Click" do
        before(:each) do
          @pending_pledges = create_list(:pending_pledge, 2, sponsor: @sponsor)
          @rejected_pledges = create_list(:rejected_pledge, 3, sponsor: @sponsor)
          @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor)
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor)           
        end

        it "should be the average of accepted and past pledges's amount_per_click" do
          pledges = @accepted_pledges + @past_pledges
          avg = pledges.map(&:amount_per_click_cents).sum/pledges.count
          expect( @sponsor.average_donation_per_click ).to eql(avg)
        end
      end

      describe "Average Clicks per Pledge" do
        before(:each) do
          @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor, clicks_count: 0)
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor, clicks_count: 0)
          @pledges = @accepted_pledges + @past_pledges

          @pledges.each do |p|
            create_list(:click, 5, pledge: p)
            p.update_attribute(:clicks_count, 5)
          end           
        end

        it "should be the total clicks divided total of accepted and past pledges" do
          avg = @pledges.map(&:clicks).flatten.count/@pledges.count
          expect( @sponsor.average_clicks_per_pledge ).to eql(avg)
        end
      end

      context 'Impressions' do
        before(:each) do
          @accepted_pledges = create_list(:pledge, 5, clicks_count: 0, sponsor: @sponsor)
          @pending_pledges = create_list(:pending_pledge, 5, clicks_count: 0, sponsor: @sponsor)
          @past_pledges = create_list(:past_pledge, 5, clicks_count: 0, sponsor: @sponsor)

          @impressions = create_list(:impression, 25, impressionable: @accepted_pledges.sample)
          @pending_impressions = create_list(:impression, 15, impressionable: @pending_pledges.sample)
          @past_impressions = create_list(:impression, 56, impressionable: @past_pledges.sample)

          @impressions_count = @impressions.count + @past_impressions.count
        end

        describe "Pledge Views" do
          it "should count all accepted and past pledge impressions" do
            expect( @sponsor.pledge_views ).to eql(@impressions_count)
          end

          it "should not include pending pledge impressions" do
            expect( @sponsor.pledge_views ).not_to eql(@pending_impressions.count)
          end
        end
        
        describe "Average Pledge Views" do
          it "should be sum of all accepted and past pledge impressions divided accepted and past pledges count" do
            pledges_count = @accepted_pledges.count + @past_pledges.count
            avg = (@impressions_count/pledges_count).floor

            expect( @sponsor.average_pledge_views ).to eql(avg)
          end

          it "should not include pending pledges" do
            avg = (@pending_impressions.count/@pending_pledges.count).floor
            expect( @sponsor.average_pledge_views ).not_to eql(avg)
          end
        end

        describe "Average Engagement" do
          before(:each) do
            accepted = @accepted_pledges.sample
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

          it "should be total_clicks divided by total launched and past pledge impressions" do
            avg = (@total_clicks.to_f/@impressions_count.to_f)
            expect( @sponsor.average_engagement ).to eql(avg)
          end

          it "should not include clicks from pending pledges" do
            avg = (@pending_clicks.count.to_f/@pending_impressions.count.to_f)
            expect( @sponsor.average_engagement ).not_to eql(avg)
          end
        end
        
      end

      describe "Top Causes" do
        before(:each) do
          @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor)   
        end

        it "should return a hash" do
          expect( @sponsor.top_causes ).to be_instance_of(Hash)
        end

        it "should list the top 3 causes" do
          expect( @sponsor.top_causes.keys.count ).to eql(3)
        end

        it "should list the causes from SP's top 3 pledges" do
          @pledges = @accepted_pledges.sort_by{|p| [p.total_amount_cents, p.amount_per_click_cents] }
          expect( @sponsor.top_causes.keys.sort ).to eql(@pledges.map(&:main_cause).uniq.first(3).sort)
        end

        it "should list the total_amount from SP's top 3 pledges" do
          @pledges = @accepted_pledges.sort_by{|p| [p.total_amount_cents, p.amount_per_click_cents] }
          expect( @sponsor.top_causes.values.sort ).to eql(@pledges.uniq(&:main_cause).map(&:total_amount).first(3).sort)
        end
      end
      
    end

    context 'SP dashboard home' do
      describe "Unique clicks from Active Pledges" do
        before(:each) do
          @pending_pledges = create_list(:pending_pledge, 2, sponsor: @sponsor, clicks_count: 0)
          @rejected_pledges = create_list(:rejected_pledge, 3, sponsor: @sponsor, clicks_count: 0)
          @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor, clicks_count: 0)
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor, clicks_count: 0)

          @pledges = @pending_pledges + @rejected_pledges + @past_pledges + @accepted_pledges

          @pledges.each do |pledge|
            create_list(:click, 5, pledge: pledge)
            pledge.update_attribute(:clicks_count, 5)
          end
        end

        it "should show the total of unique clicks from active pledges" do
          expect( @sponsor.active_pledges_clicks_count ).to eql(20)
        end

        it "should not include unique clicks from pending pledges" do
          expect( @sponsor.active_pledges_clicks_count ).not_to eql(10)
        end

        it "should not include unique clicks from rejected pledges" do
          expect( @sponsor.active_pledges_clicks_count ).not_to eql(15)
        end

        it "should not include unique clicks from past pledges" do
          expect( @sponsor.active_pledges_clicks_count ).not_to eql(25)
        end
      end

      describe "Invoices Due" do
        before(:each) do
          @sponsor.invoices.destroy_all
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor)

          @paid_invoices = []
          @outstanding_invoices = []

          @past_pledges.each do |pledge|
            @paid_invoices << create_list(:invoice, 3, pledge: pledge)
            @outstanding_invoices << create_list(:pending_invoice, 5, pledge: pledge)
          end
        end

        it "should show total dollar amount of outstanding invoices" do
          due = @outstanding_invoices.flatten.map(&:due_cents).sum
          expect( @sponsor.invoices_due ).to eql(due)
        end

        it "should not include amounts from paid invoices" do
          due = @paid_invoices.flatten.map(&:due_cents).sum
          expect( @sponsor.invoices_due ).not_to eql(due)
        end
      end

    end

  end
  
end
