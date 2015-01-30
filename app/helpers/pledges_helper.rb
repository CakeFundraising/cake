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

  def sponsor_autolink(pledge)
    if pledge.instance_of?(Pledge)
      link_to pledge.sponsor.name, pledge.sponsor
    else
      content_tag(:a, pledge.sponsor.name)
    end
  end

  def pledge_autolink(pledge)
    if pledge.instance_of?(Pledge)
      auto_link pledge
    else
      link_to pledge, quick_pledges_path
    end
  end

  def update_pledge_screenshot(pledge)
    if Rails.env.production? or Rails.env.development?
      Resque.enqueue(ResqueSchedule::CampaignScreenshot, pledge.id, pledge_url(pledge)) #update screenshot
    end
  end
end
