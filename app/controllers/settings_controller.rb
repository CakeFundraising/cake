class SettingsController < ApplicationController
  def public_profile
    @fundraiser_profile = current_user.fundraiser_profile
    @organization = current_user.organization      
  end

  #After registration form
  def complete_account
    @fundraiser_profile = current_user.fundraiser_profile
    @organization = current_user.organization         
  end
end