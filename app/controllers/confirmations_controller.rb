class ConfirmationsController < Devise::ConfirmationsController
  def show
    super
    session[:new_user] = true
  end
end