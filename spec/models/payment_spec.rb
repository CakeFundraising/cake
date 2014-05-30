require 'spec_helper'

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
    monetize(:total_cents).should be_true
  end

  it "should have statuses" do
    Payment.statuses[:status].should == [:charged, :transferred]
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
      @payment.status.should == 'charged'
      @payment.transfer!
      @payment.status.should == :transferred
    end

    it "should make a transfer to the fundraiser's bank account" do
      @payment.transfers.should be_empty
      @payment.transfer!
      @payment.transfers.should_not be_empty
    end

    it "should create a transfer object" do
      @payment.transfer!
      transfer =  @payment.transfers.first
      
      transfer.should be_instance_of(Transfer)
      transfer.amount_cents.should == ((1-CakeConstants::APPLICATION_FEE)*@payment.total_cents).round
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
      @transaction.should be_instance_of(Charge)
      @transaction.kind.should == 'charge'
      @transaction.paid.should be_true
      @transaction.amount.should == @payment.total
    end
  end
end
