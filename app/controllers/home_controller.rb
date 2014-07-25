class HomeController < ApplicationController
  before_action :go_to_registration, only: :index

  def index
    @campaigns = CampaignDecorator.decorate_collection Campaign.popular
    @sponsors = SponsorDecorator.decorate_collection Sponsor.popular
    @coupons = CouponDecorator.decorate_collection Coupon.popular
  end

  def get_started
    session.delete(:new_user)
  end

  protected

  def go_to_registration
    unless current_user.nil? or current_user.registered
      if current_user.fundraiser_email_setting.present?
        route = new_fundraiser_path
      elsif current_user.sponsor_email_setting.present?
        route = new_sponsor_path
      else
        route = home_get_started_path
      end

      redirect_to route, notice: 'Please complete your registration in CakeFundraising.'
    end
  end
end
