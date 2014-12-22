module PledgesHelper
  def cancel_pledge_link
    link_to 'Cancel', @pledge, data: {confirm: 'Are you sure?'}, method: :delete
  end

  def hidden_cancel_pledge_link
  	link_to 'Cancel', @pledge, method: :delete, class:'hidden', id: 'hidden_delete_link'
  end

  def preview_pledge_link
  	link_to "Preview", @pledge, class:'btn btn-primary pull-right'
  end

  def pledge_offers_button(pledge)
    if pledge.coupons.any?
      extra = pledge.coupons.extra_donation_pledges.any?
      copy = extra ? "Extra Special Offers" : "Special Offers"

      link_to pledge_path(pledge, anchor: :coupons), target: :_blank, class:"btn btn-#{ extra ? 'purple' : 'primary' } btn-block" do
        content_tag(:span, copy)
      end
    end
  end
end
