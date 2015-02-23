require 'rails_helper'

describe DirectDonation do
  it { should belong_to(:fundraiser) }
  it { should have_one(:charge) }

  it { should validate_presence_of(:fundraiser) }
  it { should validate_presence_of(:card_token) }
  it { should validate_presence_of(:email) }

  describe "#store_transaction" do
    before(:each) do
      WebMock.disable!
      @direct_donation = FactoryGirl.create(:direct_donation)
      @transaction = @direct_donation.charge
    end

    after(:each) do
      WebMock.enable!
    end

    it "should monetize the amount field" do
      expect(@direct_donation).to monetize(:amount_cents)
    end

    it "should store a copy of the stripe charge transaction" do
      expect(@transaction).to be_instance_of(Charge)
      expect(@transaction.kind).to eq 'charge'
      expect(@transaction.paid).to be true
      expect(@transaction.amount).to eq @direct_donation.amount
      expect(@transaction.total_fee_cents).to be_within(1).of((@direct_donation.amount_cents*(0.029+Cake::APPLICATION_FEE)).ceil + 30)
    end
  end
end
