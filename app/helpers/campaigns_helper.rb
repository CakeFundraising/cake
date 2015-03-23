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

  def wizard_menu_item(path, text, options={})
    if current_page?(path)
      content_tag(:li, class:'active') do
        content_tag(:a, text, data: {toggle: 'tab'})
      end
    else
      content_tag :li do
        link_to text, path, options
      end
    end
  end

  def campaign_page_meta
    display_meta(
      @campaign.fundraiser.name, 
      { 
        title: "Click and help support us! It is 100% free!", 
        image: "http://res.cloudinary.com/cakefundraising/image/url2png/w_1200,h_630,c_fill,g_north,r_10/#{@campaign.screenshot_version}/#{campaign_url(@campaign.id)}", 
        description: @campaign.mission, 
        url: request.original_url
      }
    )
  end

  def update_campaign_screenshot(campaign)
    if Rails.env.production? or Rails.env.development?
      Resque.enqueue(ResqueSchedule::CampaignScreenshot, campaign.id, campaign_url(campaign)) #update screenshot
    end
  end

  #Action buttons
  def edit_campaign_link(campaign)
    if can? :edit, campaign
      link_to edit_campaign_path(campaign) do
        content_tag(:span, nil, class:'glyphicon glyphicon-pencil')
      end
    end
  end

  def delete_campaign_link(campaign)
    if can? :destroy, campaign
      link_to campaign, method: :delete, data: {confirm: 'Are you sure?'}, class:'delete' do
        content_tag(:span, nil, class:'glyphicon glyphicon-trash')
      end
    end
  end
end
