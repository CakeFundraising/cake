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

  def pledge_news_pic(pledge_news)
    if pledge_news.url.nil?
      pledge_news.picture.avatar
    else
      # Link with rollover
      picture_rollover(pledge_news.picture.avatar, pledge_news.url) do
        content_tag(:div, 'Click to') + content_tag(:div, 'learn more')
      end
    end
  end

  def all_coupons_button(pledge, partial=:box)
    link_to 'See More Offers', load_all_coupons_path(pledge_id: pledge, partial: partial), remote: true, class:'btn btn-primary btn-lg load_all_coupons' if pledge.coupons.count > 2
  end

  def all_news_button(pledge, partial=:box)
    link_to 'See More', load_all_pledge_news_index_path(pledge_id: pledge, partial: partial), remote: true, class:'btn btn-primary btn-lg load_all_news' if pledge.coupons.count > 1
  end
end