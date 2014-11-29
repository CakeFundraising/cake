class ApplicationController < ActionController::Base
  ensure_security_headers
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :generate_evercookie_token
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

  def generate_evercookie_token
    unless evercookie_is_set?(:cfbid)
      @evercookie_token = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless Browser.exists?(token: random_token)
      end
      Browser.create(token: @evercookie_token)
    end
  end

  protected 

  def evercookie_is_set?(key, value = nil)
    if session[Evercookie.hash_name_for_set].blank?
      false
    elsif value.nil?
      session[Evercookie.hash_name_for_set][:key] == key
    else
      session[Evercookie.hash_name_for_set][:key] == key and session[Evercookie.hash_name_for_set][:value] == value
    end
  end

  def evercookie_get_value(key)
    if session[Evercookie.hash_name_for_set].present? and session[Evercookie.hash_name_for_set][:key] == key
      session[Evercookie.hash_name_for_set][:value]
    else
      nil
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
