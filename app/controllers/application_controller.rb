class ApplicationController < ActionController::Base
  ensure_security_headers
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_fundraiser, :current_sponsor, :current_browser

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

  def current_browser
    token = evercookie_get_value(:cfbid)
    Browser.find_by_token(token) if token.present?
  end

  protected 

  def set_evercookie(key, value)
    session[:evercookie] = {} unless session[:evercookie].present?
    session[:evercookie][key] = value
  end

  def evercookie_get_value(key)
    session[:evercookie].present? ? session[:evercookie][key] : nil
  end

  def evercookie_is_set?(key, value = nil)
    if session[:evercookie].blank?
      false
    elsif value.nil?
      session[:evercookie][key].present?
    else
      session[:evercookie][key].present? and session[:evercookie][key] == value
    end
  end

  def after_sign_in_path_for(resource)
    if current_user.present? and not current_user.registered
      if current_user.fundraiser_email_setting.present?
        new_fundraiser_path
      elsif current_user.sponsor_email_setting.present?
        new_sponsor_path
      else
        home_get_started_path
      end
    elsif cookies[:pledge_campaign].present?
      new_pledge_path(campaign: cookies[:pledge_campaign])
    elsif cookies[:pledge_fundraiser].present?
      new_pledge_path(fundraiser: cookies[:pledge_fundraiser])
    elsif current_sponsor.present?
      sponsor_home_path
    elsif current_fundraiser.present?
      fundraiser_home_path
    elsif resource.is_a? AdminUser
      admin_root_path
    else
      super
    end
  end
end
