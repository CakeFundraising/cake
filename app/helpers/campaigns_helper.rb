module CampaignsHelper
  def hidden_campaign_cancel_link
    link_to 'Cancel', @campaign, method: :delete, class:'hidden', id: 'hidden_delete_link'
  end

  def status_buttons(campaign)
    if campaign.pending?
      content_tag :span do
        link_to "Launch", launch_campaign_path(campaign), method: :patch, remote: true, class:'btn btn-success btn-sm launch_button'
      end
    elsif campaign.incomplete?
      content_tag(:div, campaign.status, class:'btn btn-sm btn-danger disabled')
    else
      content_tag(:div, campaign.status, class:'btn btn-sm btn-success disabled')
    end
  end

  def visibility_buttons(campaign)
    content_tag :div, class:'visibility_buttons' do
      content_tag :span do
        link_to("Hide", toggle_visibility_campaign_path(campaign), method: :patch, remote: true, class:"btn btn-danger btn-sm #{'hidden' unless campaign.visible}")+
        link_to("Show", toggle_visibility_campaign_path(campaign), method: :patch, remote: true, class:"btn btn-success btn-sm #{'hidden' if campaign.visible}")
      end
    end
  end
end
