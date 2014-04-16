class Fundraiser::DashboardController < ApplicationController
  def home
    @fundraiser = current_fundraiser
  end

  def billing
  end

  def pending_pledges
  end

  def campaigns
    @campaigns = current_fundraiser.campaigns.active.decorate
  end

  def history
    @campaigns = current_fundraiser.campaigns.past.decorate
    # @sponsors = ...
  end
end