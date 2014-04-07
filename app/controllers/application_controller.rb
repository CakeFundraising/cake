class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:full_name, :email, :password, :password_confirmation)}
  end

  def after_sign_in_path_for(resource)
    if session[:new_user]
      complete_account_path
    else
      super
    end
  end
end
