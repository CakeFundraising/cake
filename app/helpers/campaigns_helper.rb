module CampaignsHelper
  def hidden_campaign_cancel_link
    link_to 'Cancel', @campaign, method: :delete, class:'hidden', id: 'hidden_delete_link'
  end
end
