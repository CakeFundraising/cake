module PledgesHelper
  def cancel_pledge_link
  	link_to 'Cancel', @pledge, data: {confirm: 'Are you sure?'}, method: :delete
  end

  def preview_pledge_link
  	link_to "Preview", @pledge, class:'btn btn-primary pull-right'
  end
end
