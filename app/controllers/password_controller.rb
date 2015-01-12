class PasswordController < ApplicationController
  before_action :check_redirect_url, only: :confirm

  def confirm
    render 'devise/passwords/validation'
  end

  def verify
    password = params[:password][:password]
    redirect_url = params[:password][:redirect_url]

    if current_user.valid_password?(password)
      session[:password_confirmed] = true
      redirect_to redirect_url 
    else
      redirect_to confirm_path(url: redirect_url), alert: 'Given password is not valid.'
    end
  end

  private

  def check_redirect_url
    redirect_to root_path if params[:url].nil?
  end
end