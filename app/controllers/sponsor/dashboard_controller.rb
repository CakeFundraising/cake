class Sponsor::DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def home
    @sponsor = current_sponsor.decorate
  end

  def billing
    @outstanding_invoices = current_sponsor.outstanding_invoices.latest.decorate
    @past_invoices = current_sponsor.past_invoices.latest.decorate
  end

  def pledge_requests
    @fundraiser_requests = current_sponsor.pledge_requests.pending.latest.decorate
    @sponsor_requests = current_sponsor.pledges.not_accepted_or_past.latest.decorate
  end

  def active_pledges
    @pledges = current_sponsor.pledges.active.latest.decorate
  end

  def history
    @pledges = current_sponsor.pledges.past.latest.decorate
    @fundraisers = FundraiserDecorator.decorate_collection(current_sponsor.fundraisers_of(:past))
  end
end