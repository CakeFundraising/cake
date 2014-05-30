class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_fundraiser, :current_sponsor

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:full_name, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.for(:account_update){|u| u.permit(:full_name, :email, :password, :password_confirmation, :current_password)}
  end

  def current_fundraiser
    current_user.fundraiser if current_user.present?
  end

  def current_sponsor
    current_user.sponsor if current_user.present?
  end

  protected 

  def after_sign_in_path_for(resource)
    if session[:new_user]
      current_user.has_role?[:fundraiser] ? new_fundraiser_path : new_sponsor_path
    elsif cookies[:pledge_campaign].present?
      new_pledge_path(campaign: cookies[:pledge_campaign])
    else
      super
    end
  end
end
