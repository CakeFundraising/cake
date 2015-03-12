class CakesterRequestsController < InheritedResources::Base
  load_and_authorize_resource
  
  def destroy
    destroy! do |success, failure|
      success.html do 
        path = current_fundraiser.present? ? fundraiser_campaigns_path : cakester_campaigns_path
        message = current_fundraiser.present? ? 'Cakester removed.' : 'Campaign removed.'

        redirect_to path, notice: message
      end
    end
  end

  #Actions
  def accept
    redirect_to cakester_campaigns_path, notice: 'Request accepted.' if resource.accept!
  end

  def reject_message
  end

  def reject
    message = params[:reject_message][:message] if params[:reject_message].present?

    if message.present?
      resource.reject!(message)
      redirect_to cakester_campaigns_path, alert: "Pledge request rejected."
    else
      @cakester_request = resource
      render 'reject_message'
    end
  end

  def permitted_params
    params.permit(cakester_request: [:message, :campaign_id, :sponsor_id])
  end
end