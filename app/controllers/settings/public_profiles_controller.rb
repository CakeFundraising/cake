class Settings::PublicProfilesController < InheritedResources::Base
  def permitted_params
    params.permit(public_profile: [:cause, :name, :head_line, :profile_message, :demographic_description, 
  :email, :min_pledge, :min_click_donation, :donations_kind, :contact_name, :website, :phone,
  :banner, :avatar, :remove_banner, :remove_avatar])
  end
end
