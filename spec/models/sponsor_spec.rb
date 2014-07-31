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
    new_sponsor.picture.should_not be_nil
    new_sponsor.picture.should be_instance_of(Picture)
  end

  it "should build a location if new object" do
    new_sponsor = FactoryGirl.build(:sponsor)
    new_sponsor.location.should_not be_nil
    new_sponsor.location.should be_instance_of(Location)
  end

  context 'Association methods' do
    before(:each) do
      @sponsor = FactoryGirl.create(:sponsor)
    end

    describe "Pledges" do
      it "should show a collection of sponsor's active pledges" do
        active_pledges = create_list(:pledge, 10, sponsor: @sponsor)
        @sponsor.pledges.active.reload.should == active_pledges
      end

      it "should show a collection of sponsor's pending pledges" do
        pending_pledges = create_list(:pending_pledge, 10, sponsor: @sponsor)
        @sponsor.pledges.pending.reload.should == pending_pledges
      end

      it "should show a collection of sponsor's rejected pledges" do
        rejected_pledges = create_list(:rejected_pledge, 10, sponsor: @sponsor)
        @sponsor.pledges.rejected.reload.should == rejected_pledges
      end
    end

    describe "Fundraisers" do
      # Fundraisers are the FR of the pledges's campaigns
      it "should show a collection of sponsor's fundraisers" do
        accepted_pledges = create_list(:pledge, 10, sponsor: @sponsor)
        pending_pledges = create_list(:pending_pledge, 10, sponsor: @sponsor)
        rejected_pledges = create_list(:rejected_pledge, 10, sponsor: @sponsor)

        @sponsor.fundraisers.should == accepted_pledges.map(&:fundraiser).uniq
        @sponsor.fundraisers.should_not include(pending_pledges.map(&:fundraiser))
        @sponsor.fundraisers.should_not include(rejected_pledges.map(&:fundraiser))
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
            invoice.status.should_not == 'paid'
          end
        end

        it "should list invoices of past accepted pledges" do
          @sponsor.outstanding_invoices.each do |invoice|
            invoice.pledge.should be_past
            invoice.pledge.should_not be_active
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
            invoice.status.should == 'paid'
          end
        end

        it "should list invoices of past accepted pledges" do
          @sponsor.past_invoices.each do |invoice|
            invoice.pledge.should be_past
            invoice.pledge.should_not be_active
          end
        end
      end
    end

  end

  context 'Analytics' do
    before(:each) do
      @sponsor = FactoryGirl.create(:sponsor)
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

      describe 'Total Clicks' do
        it "should be the sum of all clicks from accepted and past pledges to SP’s websites" do
          @accepted_pledges = create_list(:pledge, 5, sponsor: @sponsor)
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor)

          pledges = @accepted_pledges + @past_pledges
          expect(@sponsor.total_clicks).to eql(pledges.map(&:clicks_count).sum)        
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
          FactoryGirl.create(:invoice, sponsor: @sponsor, due_cents: 1000)

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
          FactoryGirl.create(:invoice, sponsor: @sponsor, due_cents: 1000)

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
          end           
        end

        it "should be the total clicks divided total of accepted and past pledges" do
          avg = @pledges.map(&:clicks).flatten.count/@pledges.count
          expect( @sponsor.average_clicks_per_pledge ).to eql(avg)
        end
      end

      describe "Top Causes" do
        it "should return a hash" do
          expect( @sponsor.top_causes ).to be_instance_of(Hash)
        end

        it "should list the top 3 causes" do
          pending 'Define which causes should it list'
        end
      end
      
    end

    context 'SP dashboard home' do
      describe "Total clicks from Active Pledges" do
        before(:each) do
          @pending_pledges = create_list(:pending_pledge, 2, sponsor: @sponsor, clicks_count: 0)
          @rejected_pledges = create_list(:rejected_pledge, 3, sponsor: @sponsor, clicks_count: 0)
          @accepted_pledges = create_list(:pledge, 4, sponsor: @sponsor, clicks_count: 0)
          @past_pledges = create_list(:past_pledge, 5, sponsor: @sponsor, clicks_count: 0)
          @pledges = @pending_pledges + @rejected_pledges + @past_pledges + @accepted_pledges

          @pledges.each do |pledge|
            create_list(:click, 5, pledge: pledge)
          end
        end

        it "should show the total of clicks from active pledges" do
          expect( @sponsor.active_pledges_clicks_count ).to eql(20)
        end

        it "should not include clicks from pending pledges" do
          expect( @sponsor.active_pledges_clicks_count ).not_to eql(10)
        end

        it "should not include clicks from rejected pledges" do
          expect( @sponsor.active_pledges_clicks_count ).not_to eql(15)
        end

        it "should not include clicks from past pledges" do
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
