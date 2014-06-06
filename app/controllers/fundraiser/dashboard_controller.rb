class Fundraiser::DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def home
    @fundraiser = current_fundraiser
  end

  def billing
    @fundraiser = current_fundraiser.decorate
    @campaigns_with_outstanding_invoices = CampaignDecorator.decorate_collection current_fundraiser.campaigns.with_outstanding_invoices
    @campaigns_with_past_invoices = CampaignDecorator.decorate_collection current_fundraiser.campaigns.with_paid_invoices
  end

  def pending_pledges
    @unsolicited_pledges = current_fundraiser.pledges.pending.decorate
    @requested_pledges = current_fundraiser.pledge_requests.decorate
  end

  def campaigns
    @campaigns = current_fundraiser.campaigns.current.decorate
  end

  def history
    @campaigns = current_fundraiser.campaigns.past.decorate
    @sponsors = SponsorDecorator.decorate_collection(current_fundraiser.sponsors)
  end
end