class Fundraiser::DashboardController < ApplicationController
  def home
    @fundraiser = current_fundraiser
  end

  def billing
  end

  def pending_pledges
    @unsolicited_pledges = current_fundraiser.pledges.pending.decorate
    @requested_pledges = current_fundraiser.pledge_requests.decorate
  end

  def campaigns
    @campaigns = current_fundraiser.campaigns.active.decorate
  end

  def history
    @campaigns = current_fundraiser.campaigns.past.decorate
    @sponsors = current_fundraiser.sponsors
  end
end