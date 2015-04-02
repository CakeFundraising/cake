class Cakester::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_cakester
  
  def home
    @cakester = current_cakester.decorate
    #@stripe_account = current_cakester.stripe_account
  end

  def billing
    @campaigns_with_outstanding_invoices = CampaignDecorator.decorate_collection current_cakester.campaigns.with_outstanding_invoices
    # @qp_invoices = current_cakester.qp_invoices.due_to_pay.latest.decorate
    @stripe_account = current_cakester.stripe_account
  end

  def pledges
    @requested_pledges = current_cakester.pledge_requests.latest.decorate
    @pending_pledges = current_cakester.pledges.normal.pending.latest.decorate
    @accepted_pledges = current_cakester.pledges.normal.accepted.latest.decorate
  end

  def campaigns
    @exclusive_clients = current_cakester.ap_cakester_requests.latest.decorate
    @non_exclusive_clients = current_cakester.campaign_cakesters.with_campaign.regular.active.decorate
  end

  def history
    # @campaigns = current_cakester.campaigns.past.latest.decorate
    @campaigns_with_past_invoices = CampaignDecorator.decorate_collection current_cakester.campaigns.with_paid_invoices
    # @paid_qp_invoices = current_cakester.qp_invoices.paid.latest.decorate
    # @sponsors = SponsorDecorator.decorate_collection(current_cakester.sponsors_of(:past))
  end

  private

  def ensure_cakester
    unless current_cakester.present?
      sign_out current_user
      redirect_to new_user_registration_path, alert: 'Please login as a Cakester to see this content.'
    end
  end
end