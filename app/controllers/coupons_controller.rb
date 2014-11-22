class CouponsController < InheritedResources::Base
  respond_to :pdf, only: :download

  def new
    @coupon = Coupon.new(pledge_id: params[:pledge_id])
    @pledge = Pledge.find(params[:pledge_id])
  end

  def edit
    @pledge = resource.pledge
  end

  def create
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
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html do
        redirect_to add_coupon_pledge_path(resource.pledge)
      end
    end
  end

  def download
    respond_with(resource) do |format|
      format.html do
        pdf = CouponPdf.new(resource.decorate)
        send_data pdf.render, filename: "#{resource.sponsor.name.titleize}-#{resource.title.titleize}.pdf", type: 'application/pdf'
      end
      format.pdf do
        render nothing: true
      end
    end
  end

  def permitted_params
    params.permit(
      coupon: [
        :id, :title, :expires_at, :promo_code, :description, :terms_conditions, :avatar, :pledge_id,
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