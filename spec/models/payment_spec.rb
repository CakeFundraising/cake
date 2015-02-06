require 'rails_helper'

describe Payment do
  it { should validate_presence_of(:kind) }
  it { should validate_presence_of(:total) }
  it { should validate_presence_of(:item) }
  it { should validate_presence_of(:payer) }
  it { should validate_presence_of(:recipient) }

  it { should belong_to(:item) }
  it { should belong_to(:payer) }
  it { should belong_to(:recipient) }

  it { should have_many(:charges) }
  it { should have_many(:transfers) }

  it "should monetize the total field" do
    payment = FactoryGirl.create(:payment)
    expect(payment).to monetize(:total_cents)
  end

  it "should have statuses" do
    expect(Payment.statuses[:status]).to eq [:charged, :transferred]
  end

  describe "#transfer!" do
    before(:each) do
      WebMock.disable!
      @payment = FactoryGirl.create(:payment)
    end

    after(:each) do
      WebMock.enable!
    end

    it "should set the payment as transferred" do
      expect(@payment.status).to eq 'charged'
      @payment.transfer!
      expect(@payment.status).to eq 'transferred'
    end

    it "should make a transfer to the fundraiser's bank account" do
      expect(@payment.transfers).to be_empty
      @payment.transfer!
      expect(@payment.transfers).to_not be_empty
    end

    it "should create a transfer object" do
      @payment.transfer!
      transfer =  @payment.transfers.first
      
      expect(transfer).to be_instance_of(Transfer)
      expect(transfer.amount_cents).to eq ((1-Cake::APPLICATION_FEE)*@payment.total_cents).round
    end
  end

  describe "#store_transaction" do
    before(:each) do
      WebMock.disable!
      @payment = FactoryGirl.create(:payment)
      @transaction = @payment.charges.first
    end

    after(:each) do
      WebMock.enable!
    end

    it "should store a copy of the stripe charge transaction" do
      expect(@transaction).to be_instance_of(Charge)
      expect(@transaction.kind).to eq 'charge'
      expect(@transaction.paid).to be true
      expect(@transaction.amount).to eq @payment.total
    end
  end
end
