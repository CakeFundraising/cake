class CakesterRequestsController < InheritedResources::Base
  load_and_authorize_resource
  
  def destroy
    destroy! do |success, failure|
      success.html{ redirect_to fundraiser_pledges_path }
    end
  end

  #Actions
  def accept
    redirect_to cakester_campaigns_path, notice: 'Request accepted.' if resource.accept!
  end

  def reject
    message = params[:reject_message][:message] if params[:reject_message].present?

    if message.present?
      resource.notify_rejection(message) if resource.rejected!
      redirect_to sponsor_cakester_requests_path, alert: "Pledge request rejected."
    else
      @cakester_request = resource
      render 'pr_reject_message'
    end
  end

  def permitted_params
    params.permit(cakester_request: [:message, :campaign_id, :sponsor_id])
  end
end