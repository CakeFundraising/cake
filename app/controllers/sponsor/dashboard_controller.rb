class Sponsor::DashboardController < ApplicationController
  def home
    @sponsor = current_sponsor
  end

  def billing
  end

  def pledge_requests
    @fr_requests = current_sponsor.pledge_requests
    @sponsor_requests = current_sponsor.pledges.pending
  end

  def active_pledges
    @pledges = current_sponsor.pledges.active
  end

  def history
    @pledges = current_sponsor.pledges.past
    @fundraisers = current_sponsor.fundraisers
  end
end