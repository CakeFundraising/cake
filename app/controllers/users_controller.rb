class UsersController < ApplicationController
  def index
  end

  def roles
  	role = params[:role]

  	if role == 'fundraiser'
  	  current_user.create_fundraiser_email_setting
  	  current_user.roles = [:fundraiser]
  	  redirect_to new_fundraiser_path if current_user.save
  	else
  	  current_user.create_sponsor_email_setting
  	  current_user.roles = [:sponsor]
  	  redirect_to new_sponsor_path if current_user.save
  	end
  end
end
