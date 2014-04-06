class RegistrationsController < Devise::RegistrationsController

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

    unless @user.new_record?
      session[:omniauth] = nil
      session[:user_role] = nil
    end
  end
  
  private

  def build_resource(*args)
    if params[:role].present?
      session[:user_role] = params[:role].to_sym
      super
    else
      @user = User.new_with(session[:omniauth], session[:user_role], args.first)
    end
  end
end