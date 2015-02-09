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

  def all_coupons_button(pledge, partial=:box)
    link_to 'See More Offers', load_all_coupons_path(pledge_id: pledge, partial: partial), remote: true, class:'btn btn-primary load_all_coupons' if pledge.coupons.count > 2
  end
end