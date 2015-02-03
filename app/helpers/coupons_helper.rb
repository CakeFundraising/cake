module CouponsHelper
  def coupon_pic(coupon)
    if coupon.url.nil?
      coupon.picture.avatar
    else
      # Link with rollover
      picture_rollover(coupon.picture.avatar, coupon.url) do
        content_tag(:div, 'Click to learn more') + content_tag(:div, 'about this offer!')
      end
    end
  end
end