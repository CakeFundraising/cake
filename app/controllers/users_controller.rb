class UsersController < ApplicationController
  def index
  end

  def roles
  	role = params[:role]

  	if role == 'fundraiser'
  	  current_user.create_fundraiser_email_setting
  	  redirect_to new_fundraiser_path
  	elsif role == 'sponsor'
  	  current_user.create_sponsor_email_setting
  	  redirect_to new_sponsor_path
    else
      current_user.create_cakester_email_setting
      redirect_to new_cakester_path
  	end
  end
end
