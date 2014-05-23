class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    callback_of("Twitter")
  end

  def facebook
    callback_of("Facebook")
  end

  def linkedin
    callback_of("Linkedin")
  end

  def stripe_connect
    @stripe_account = current_fundraiser.create_stripe_account(request.env["omniauth.auth"])
    redirect_to bank_account_fundraiser_path(current_fundraiser), notice: "Please add your bank account information" if @stripe_account
  end

  def callback_of(provider)
    @user = User.find_user_from(request.env["omniauth.auth"])

    if @user.blank?
      session[:omniauth] = request.env["omniauth.auth"].except("extra")
      flash[:info] = t('messages.flash.omniauth')
      redirect_to new_user_registration_url
    else
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => provider) if is_navigational_format?
    end
  end
end