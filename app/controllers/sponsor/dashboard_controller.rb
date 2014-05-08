class Sponsor::DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def home
    @sponsor = current_sponsor
  end

  def billing
  end

  def pledge_requests
    @fundraiser_requests = current_sponsor.pledge_requests.pending.decorate
    @sponsor_requests = current_sponsor.pledges.not_accepted.decorate
  end

  def active_pledges
    @pledges = current_sponsor.pledges.active.decorate
  end

  def history
    @pledges = current_sponsor.pledges.past.decorate
    @fundraisers = FundraiserDecorator.decorate_collection(current_sponsor.fundraisers)
  end
end