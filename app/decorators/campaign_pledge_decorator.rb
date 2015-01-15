# Pledge & QuickPledge minipledge integrator

class CampaignPledgeDecorator < PledgeDecorator 
  def sponsor_autolink
    if object.is_a?(Pledge)
      h.link_to object.sponsor.name, object.sponsor
    else
      h.content_tag(:a, object.sponsor.name)
    end
  end

  def sponsor_location
    [object.sponsor.city, object.sponsor.state_code].join(', ')
  end

  def link_button
    h.link_to('See Our Pledge', object, target: :_blank, class:'btn btn-success btn-block') if object.is_a?(Pledge)
  end

  def coupons_button
    if object.is_a?(Pledge) and object.coupons.any?
      extra = object.coupons.extra_donation_pledges.any?
      copy = extra ? "Extra Special Offers" : "Special Offers"

      h.link_to h.pledge_path(object, anchor: :coupons), target: :_blank, class:"btn btn-#{ extra ? 'purple' : 'primary' } btn-block" do
        h.content_tag(:span, copy)
      end
    end
  end

  def click_path
    object.is_a?(Pledge) ? h.click_pledge_path(object) : h.click_quick_pledge_path(object)
  end
end