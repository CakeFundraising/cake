class UsersController < ApplicationController
  def index
  end

  def roles
  	role = params[:role]

  	if role == 'fundraiser'
  	  current_user.create_fundraiser_email_setting
  	  redirect_to new_fundraiser_path
  	else
  	  current_user.create_sponsor_email_setting
  	  redirect_to new_sponsor_path
  	end
  end
end
