require 'spec_helper'

describe DirectDonation do
  it { should belong_to(:campaign) }
  it { should have_one(:charge) }

  it { should validate_presence_of(:campaign) }
  it { should validate_presence_of(:card_token) }
  it { should validate_presence_of(:email) }
  
  it "should monetize the amount field" do 
    monetize(:amount_cents).should be_true
  end

  describe "#store_transaction" do
    before(:each) do
      WebMock.disable!
      @direct_donation = FactoryGirl.create(:direct_donation)
      @transaction = @direct_donation.charge
    end

    after(:each) do
      WebMock.enable!
    end

    it "should store a copy of the stripe charge transaction" do
      @transaction.should be_instance_of(Charge)
      @transaction.kind.should == 'charge'
      @transaction.paid.should be_true
      @transaction.amount.should == @direct_donation.amount
      @transaction.total_fee_cents.should be_within(1).of((@direct_donation.amount_cents*(0.029+CakeConstants::APPLICATION_FEE)).ceil + 30)
    end
  end
end
