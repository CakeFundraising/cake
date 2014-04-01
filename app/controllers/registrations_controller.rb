class RegistrationsController < Devise::RegistrationsController
  before_action :redirect_to_getting_started, only: :new

  def create
    build_resource(sign_up_params)
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
    session[:omniauth] = nil unless @user.new_record?
  end
  
  private

  def redirect_to_getting_started
    redirect_to home_get_started_path unless params[:role].present? or session[:omniauth].present?
  end

  def build_resource(*args)
    super
    if session[:omniauth] && params[:user].blank?
      @user = User.new_user_with(session[:omniauth])
    end
  end
end