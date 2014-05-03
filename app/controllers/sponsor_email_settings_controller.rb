class SponsorEmailSettingsController < InheritedResources::Base
  defaults singleton: true
  belongs_to :user

  before_action :set_user

  def update
    update! do |success, failure|
      success.html do
        redirect_to edit_sponsor_email_settings_path, notice: 'Email Settings successfully saved.'
      end
    end
  end

  def permitted_params
    params.permit(sponsor_email_setting: 
      [:new_pledge_request, :pledge_increased, :pledge_fully_subscribed, :pledge_accepted, :pledge_rejected, 
       :campaign_end, :missed_launch_campaign, :account_change, :public_profile_change, :campaign_launch])
  end

  private

  def set_user
    params[:user_id] = current_user.id #Hack to InheritedResources to find the parent
  end
end