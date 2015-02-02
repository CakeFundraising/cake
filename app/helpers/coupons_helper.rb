module CouponsHelper
  def coupon_pic(coupon)
    if coupon.url.nil?
      coupon.picture.avatar
    else
      link_to coupon.url, target: :_blank do
        coupon.picture.avatar
      end
    end
  end
end