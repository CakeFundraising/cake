class Sponsor::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_sponsor
  
  def home
    @sponsor = current_sponsor.decorate
    @stripe_account = current_sponsor.stripe_account
  end

  def billing
    @outstanding_invoices = current_sponsor.outstanding_invoices.latest.decorate
    @past_invoices = current_sponsor.past_invoices.latest.decorate
    @stripe_account = current_sponsor.stripe_account
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

  private

  def ensure_sponsor
    unless current_sponsor.present?
      sign_out current_user
      redirect_to new_user_registration_path, alert: 'Please login as a Sponsor to see this content.'
    end
  end
end