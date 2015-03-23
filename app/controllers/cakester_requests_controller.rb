class CakesterRequestsController < InheritedResources::Base
  load_and_authorize_resource

  def new
    @cakester = Cakester.find(params[:cakester]).decorate
    @cakester_request = @cakester.cakester_requests.build
  end

  def create
    create! do |success, failure|
      success.html do
        redirect_to fundraiser_campaigns_path
      end
    end
  end

  def delete
    @partner = current_fundraiser.present? ? resource.cakester.decorate : resource.fundraiser.decorate
  end
  
  def destroy
    message = params[:delete_message][:message] if params[:delete_message].present?
    resource.notify_termination(message, current_user.id) if message.present?

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
      redirect_to cakester_campaigns_path, notice: "Pledge request rejected."
    else
      @cakester_request = resource
      render 'reject_message'
    end
  end

  def permitted_params
    params.permit(cakester_request: [:message, :campaign_id, :sponsor_id, :cakester_id, :rate])
  end
end