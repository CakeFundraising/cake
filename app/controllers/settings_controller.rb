class SettingsController < ApplicationController
  def public_profile
    @fundraiser = current_user.fundraiser
  end
end