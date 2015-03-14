class PledgeRequestsController < InheritedResources::Base
  load_and_authorize_resource
  before_action :get_requester, only: [:new, :create]
  
  def new
    @pledge_request = @requester.pledge_requests.build(sponsor_id: params[:sponsor_id])
    @sponsor = @pledge_request.sponsor.decorate
    @campaigns = @requester.campaigns.active
  end
  
  def create
    @pledge_request = @requester.pledge_requests.build(permitted_params[:pledge_request])
    message = permitted_params[:pledge_request][:message]
    
    create! do |success, failure|
      success.html do
        @pledge_request.notify_sponsor(message)
        redirect_to requester_path 
      end
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html{ redirect_to requester_path }
    end
  end

  #Actions
  def accept
    redirect_to new_pledge_path(campaign: resource.campaign, pledge_request: resource), notice: 'Please complete your pledge offer.'
  end

  def reject
    message = params[:reject_message][:message] if params[:reject_message].present?

    if message.present?
      resource.notify_rejection(message) if resource.rejected!
      redirect_to sponsor_pledge_requests_path, notice: "Pledge request rejected."
    else
      @pledge_request = resource
      render 'pr_reject_message'
    end
  end

  private

  def get_requester
    @requester = current_fundraiser || current_cakester
  end

  def requester_path
    send("#{current_user.roles.first}_pledges_path")
  end

  def permitted_params
    params.permit(pledge_request: [:message, :campaign_id, :sponsor_id])
  end
end
