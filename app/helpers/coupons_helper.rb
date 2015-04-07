module CouponsHelper
  def coupon_pic(coupon)
    if coupon.url.nil?
      coupon.picture.avatar
    else
      # Link with rollover
      picture_rollover(coupon.picture.avatar, click_coupon_path(coupon)) do
        content_tag(:div, 'Click to learn more') + content_tag(:div, 'about this offer!')
      end
    end
  end

  def pledge_news_pic(pledge_news)
    if pledge_news.url.nil?
      pledge_news.picture.avatar
    else
      # Link with rollover
      picture_rollover(pledge_news.picture.avatar, click_pledge_news_path(pledge_news)) do
        content_tag(:div, 'Click to') + content_tag(:div, 'learn more')
      end
    end
  end

  def all_coupons_button(pledge, partial=:box)
    if pledge.coupons.count > 2
      content_tag(:div, class: :see_more) do
        link_to('See More Offers', load_all_coupons_path(pledge_id: pledge, partial: partial), remote: true, class:'btn btn-primary btn-lg load_all_coupons') + 
        content_tag(:div, class: 'hidden page-spinner') do
          image_tag 'loading.gif'
        end
      end
    end
  end

  def all_news_button(pledge, partial=:box)
    if pledge.pledge_news.count > 1
      content_tag(:div, class: :see_more) do
        link_to('See More', load_all_pledge_news_index_path(pledge_id: pledge, partial: partial), remote: true, class:'btn btn-primary btn-lg load_all_news') + 
        content_tag(:div, class: 'hidden page-spinner') do
          image_tag 'loading.gif'
        end
      end
    end
  end

  def coupon_print_button(coupon)
    link_to download_coupon_path(coupon), class:'btn btn-primary coupon_print_button extra_click_link' do
      content_tag(:span, nil, class: 'glyphicon glyphicon-print') + 
      content_tag(:span, ' Print Coupon')
    end
  end
end