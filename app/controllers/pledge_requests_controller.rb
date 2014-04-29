class PledgeRequestsController < InheritedResources::Base
  authorize_resource
  
  def new
    @pledge_request = current_fundraiser.pledge_requests.build(sponsor_id: params[:sponsor_id])
  end
  
  def create
    @pledge_request = current_fundraiser.pledge_requests.build(permitted_params[:pledge_request])
    create! do |success, failure|
      success.html do
        redirect_to fundraiser_pending_pledges_path
      end
    end
  end

  def permitted_params
    params.permit(pledge_request: [:campaign_id, :sponsor_id])
  end
end
