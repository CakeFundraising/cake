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

  #Actions
  def accept
    redirect_to new_pledge_path(campaign: resource.campaign), notice: 'Plese complete your pledge offer'
  end

  def reject
    resource.notify_rejection if resource.rejected!
    redirect_to sponsor_pledge_requests_path, alert: "Pledge request rejected."
  end

  def permitted_params
    params.permit(pledge_request: [:campaign_id, :sponsor_id])
  end
end
