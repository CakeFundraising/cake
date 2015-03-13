class Fundraiser::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_fundraiser
  
  def home
    @fundraiser = current_fundraiser.decorate
    @stripe_account = current_fundraiser.stripe_account
  end

  def billing
    @fundraiser = current_fundraiser.decorate
    @campaigns_with_outstanding_invoices = CampaignDecorator.decorate_collection current_fundraiser.campaigns.with_outstanding_invoices
    @qp_invoices = current_fundraiser.qp_invoices.due_to_pay.latest.decorate
    @stripe_account = current_fundraiser.stripe_account
  end

  def pledges
    @unsolicited_pledges = current_fundraiser.pledges.normal.pending.latest.decorate
    @requested_pledges = current_fundraiser.pledge_requests.latest.decorate
    @accepted_pledges = current_fundraiser.pledges.normal.accepted.latest.decorate
  end

  def campaigns
    @campaigns = current_fundraiser.campaigns.active.with_pledges.with_campaign_cakesters.with_cakester_requests.latest.decorate
  end

  def history
    @campaigns = current_fundraiser.campaigns.past.latest.decorate
    @campaigns_with_past_invoices = CampaignDecorator.decorate_collection current_fundraiser.campaigns.with_paid_invoices
    @paid_qp_invoices = current_fundraiser.qp_invoices.paid.latest.decorate
    @sponsors = SponsorDecorator.decorate_collection(current_fundraiser.sponsors_of(:past))
  end

  private

  def ensure_fundraiser
    unless current_fundraiser.present?
      sign_out current_user
      redirect_to new_user_registration_path, alert: 'Please login as a Fundraiser to see this content.'
    end
  end
end