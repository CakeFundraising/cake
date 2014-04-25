class PledgeRequestsController < InheritedResources::Base
  def permitted_params
    params.permit(pledge_request: [:campaign_id])
  end
end
