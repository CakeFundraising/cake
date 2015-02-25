class CakestersController < InheritedResources::Base
  before_action :check_if_account_created, only: [:new, :create]

  def show
    @cakester = resource.decorate
  end

  def create
    @cakester = Cakester.new(*resource_params)
    @cakester.build_location(resource_params.first['location_attributes'])
    @cakester.manager = current_user

    create! do |success, failure|
      success.html do
        current_user.set_role(@cakester)
        redirect_to cakester_home_path, notice: 'Now you can start creating a new campaign!'  
      end
    end
  end

  def update
    update! do |success, failure|
      success.html do
        send_notification
        redirect_to resource, notice: 'Profile saved.'
      end
    end
  end

  private

  def send_notification
    resource.notify_update
  end

  def check_if_account_created
    redirect_to root_path, alert:'Please sign out and create a new account if you want to create a new Cakester account.' if current_user.nil? or current_cakester.present?
  end

  def permitted_params
    params.permit(
      cakester: [
        :name, :email, :phone, :website, :manager_name, :manager_email, :manager_title, :manager_phone, 
        :mission, :about, :email_subscribers, :facebook_subscribers, :twitter_subscribers, :pinterest_subscribers,
        causes:[], scopes: [], cause_requirements: [],
        location_attributes: [:address, :city, :zip_code, :state_code, :country_code],
        picture_attributes: [
          :id, :banner, :avatar, :avatar_caption,
          :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
          :banner_crop_x, :banner_crop_y, :banner_crop_w, :banner_crop_h
        ]
      ]
    )
  end
end

