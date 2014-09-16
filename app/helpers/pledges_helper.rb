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
end
