require 'rails_helper'

describe Coupon do
  it { should belong_to(:pledge) }
  it { should have_one(:sponsor).through(:pledge) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:expires_at) }
  it { should validate_presence_of(:pledge) }

  # it "should validate extra donation pledges when user creates one" do
  #   subject.stub(:extra_donation_pledge) { true } 
  #   should validate_numericality_of(:unit_donation).with_message("must be an integer").is_greater_than(0).is_less_than_or_equal_to(1000)
  #   should validate_numericality_of(:total_donation).with_message("must be an integer").is_greater_than(0)
  # end

  it "should set default terms and conditions" do
    new_coupon = FactoryGirl.build(:coupon)
    expect(new_coupon.terms_conditions).to_not be_nil
    expect(new_coupon.terms_conditions).to eq I18n.t('application.terms_and_conditions.coupons')
  end

  it "should return the collection of normal coupons" do
    @coupons = create_list(:coupon, 5)
    expect(Coupon.normal).to eq @coupons
  end

  it "should return the collection of extra_donation_pledges" do
    @extra_donation_pledges = create_list(:extra_donation_pledge, 5)
    expect(Coupon.extra_donation_pledges).to eq @extra_donation_pledges
  end
end
