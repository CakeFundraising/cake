class HomeController < ApplicationController
  def index
    @campaigns = CampaignDecorator.decorate_collection Campaign.popular
    @sponsors = SponsorDecorator.decorate_collection Sponsor.popular
    @coupons = CouponDecorator.decorate_collection Coupon.popular
  end

  def get_started
    session.delete(:new_user)
  end
end
