class SettingsController < ApplicationController
  def public_profile
    @fundraiser = current_fundraiser
    @sponsor = current_sponsor

    render 'fundraiser_public_profile' if @fundraiser.present?
    render 'sponsor_public_profile' if @sponsor.present?
  end
end