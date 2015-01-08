require 'rails_helper'

describe Sweepstake do
  it { should belong_to(:pledge) }
  it { should have_one(:sponsor).through(:pledge) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:avatar) }
  it { should validate_presence_of(:winners_quantity) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:terms_conditions) }
  it { should validate_presence_of(:claim_prize_instructions) }
  it { should validate_presence_of(:pledge) }

  it "should set default terms and conditions" do
    new_coupon = FactoryGirl.build(:coupon)
    new_coupon.terms_conditions.should_not be_nil
    new_coupon.terms_conditions.should == I18n.t('application.terms_and_conditions.coupons')
  end
end
