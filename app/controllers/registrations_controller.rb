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

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      resource.notify_account_update
      redirect_to edit_user_registration_path
    else
      clean_up_passwords resource
      respond_with resource
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

  def after_sign_up_path_for(resource)
    complete_account_path
  end
end