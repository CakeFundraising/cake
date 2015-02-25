class SettingsController < ApplicationController
  def public_profile
    @fundraiser = current_fundraiser
    @sponsor = current_sponsor
    @cakester = current_cakester

    render 'fundraiser_edit_profile' if @fundraiser.present?
    render 'sponsor_edit_profile' if @sponsor.present?
    render 'cakester_edit_profile' if @cakester.present?
  end
end