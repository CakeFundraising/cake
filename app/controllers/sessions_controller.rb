class SessionsController < Devise::SessionsController
  before_action :clear_cookies, only: :new

  protected

  def clear_cookies
    cookies.delete(:pledge_campaign) if cookies[:pledge_campaign].present?
    cookies.delete(:pledge_fundraiser) if cookies[:pledge_fundraiser].present?  
  end
end