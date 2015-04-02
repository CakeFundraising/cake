class CakestersController < InheritedResources::Base
  include BankAccountController
  
  before_action :check_if_account_created, only: [:new, :create]
  before_action :allow_only_cakesters, only: [:accept_campaign, :bank_account]

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


  def accept_campaign
    campaign = Campaign.find(params[:campaign])

    if current_cakester.add_campaign(campaign)
      redirect_to cakester_campaigns_path, notice: 'Campaign added to Non-Exclusive Clients tab.'
    else
      redirect_to root_path, alert: 'There was an error when trying to add this Campaign, please try again.'
    end
  end

  private

  #Bank Account
  def after_ba_set_path
    cakester_home_path
  end

  def ba_path
    bank_account_cakester_path(current_cakester)
  end

  def send_notification
    resource.notify_update
  end

  def check_if_account_created
    redirect_to root_path, alert:'Please sign out and create a new account if you want to create a new Cakester account.' if current_user.nil? or current_cakester.present?
  end

  def allow_only_cakesters
    unless current_cakester.present?
      sign_out current_user if current_user.present?
      redirect_to new_user_registration_path, alert: "In order to take this action you have first to register as a Cakester."
    end
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
