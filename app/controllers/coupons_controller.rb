class CouponsController < InheritedResources::Base
  respond_to :pdf, only: :download
  load_and_authorize_resource

  include UrlHelper

  def new
    @coupon = Coupon.new(pledge_id: params[:pledge_id])
    @pledge = Pledge.find(params[:pledge_id])
    authorize! :new, @coupon
  end

  def edit
    @pledge = resource.pledge
  end

  def create
    @pledge = resource.pledge
    create! do |success, failure|
      success.html do
        redirect_to add_coupon_pledge_path(resource.pledge)
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        redirect_to add_coupon_pledge_path(resource.pledge)
      end
      failure.html do
        @pledge = resource.decorate
        render :edit
      end
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html do
        redirect_to add_coupon_pledge_path(resource.pledge)
      end
    end
  end

  def click(redirect=true)
    if current_browser.present?
      if resource.pledge.active?
        resource.extra_clicks.create(browser: current_browser) unless resource.unique_click_browsers.include?(current_browser)
      end
      redirect_to url_with_protocol(resource.url) if redirect
    else
      redirect_to resource.pledge, alert: 'There was an error when trying to count your click. Please try again.' if redirect
    end
  end

  def download
    self.click(redirect=false)
    respond_with(resource) do |format|
      format.html do
        pdf = CouponPdf.new(resource.decorate)
        send_data pdf.render, filename: "#{resource.sponsor.name.titleize}-#{resource.title.titleize}.pdf", type: 'application/pdf'
      end
    end
  end

  def load_all
    @pledge = Pledge.find(params[:pledge_id]).decorate
    @coupons = CouponDecorator.decorate_collection @pledge.coupons.latest.offset(2)
    @partial = params[:partial]

    @coupons.any? ? render(:load_all, layout: false) : render(nothing: true)
  end

  def permitted_params
    params.permit(
      coupon: [
        :id, :title, :expires_at, :promo_code, :description, :terms_conditions, :avatar, :pledge_id, :url,
        :extra_donation_pledge, :unit_donation, :total_donation, :standard_terms, :_destroy, :qrcode, :qrcode_cache, merchandise_categories: [],
        picture_attributes: [
          :id, :banner, :avatar, :qrcode, :avatar_caption,
          :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
          :banner_crop_x, :banner_crop_y, :banner_crop_w, :banner_crop_h,
          :qrcode_crop_x, :qrcode_crop_y, :qrcode_crop_w, :qrcode_crop_h
        ]
      ]
    )
  end
end