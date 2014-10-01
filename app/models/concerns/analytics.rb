module Analytics
  extend ActiveSupport::Concern

  included do
    alias_method :total_raised, :total_donation
  end

  def analytics_pledges
    pledges.accepted_or_past
  end

  ### General
  def total_donation
    invoices.paid.sum(:due_cents).to_i
  end

  def total_clicks
    analytics_pledges.sum(:clicks_count).to_i
  end

  def rank
    total_ranking = self.class.rank
    rank = total_ranking.find_index(self) || total_ranking.count
    rank + 1
  end

  def local_rank
    total_ranking = self.class.local_rank(self.location.zip_code)
    rank = total_ranking.find_index(self) || total_ranking.count
    rank + 1
  end

  ## Averages
  def any_pledges?
    analytics_pledges.any?
  end

  def pledges_count
    analytics_pledges.count
  end

  def average_pledge
    return 0 unless any_pledges?
    (analytics_pledges.to_a.sum(&:total_amount_cents)/pledges_count) 
  end

  def average_donation
    return 0 unless invoices.paid.any?
    (total_donation/invoices.paid.count)
  end

  def average_donation_per_click
    return 0 unless any_pledges?
    (analytics_pledges.sum(:amount_per_click_cents)/pledges_count)
  end

  def average_clicks_per_pledge
    return 0 unless any_pledges?
    (total_clicks/pledges_count).floor
  end

  def top_pledges(limiter)
    analytics_pledges.highest.limit(limiter)
  end

  def top_causes # {cause_name: pledge_amount}
    pledges = analytics_pledges.highest.with_campaign

    top_causes = pledges.inject({}) do |top_causes, pledge|
      top_causes = (top_causes.has_key?(pledge.main_cause) or top_causes.keys.count == 3) ? top_causes : top_causes.merge({pledge.main_cause => pledge.total_amount})
    end
    
    top_causes
  end

  def invoices_due
    outstanding_invoices.sum(:due_cents).to_i
  end

  #### Correlated analytics ####
  ## Avg. Donation
  def paid_invoices_to(user_role)
    if self.is_a?(Sponsor)
      invoices.paid.merge pledges.fundraiser(user_role)
    else
      invoices.paid.merge pledges.sponsor(user_role)
    end
  end

  def total_donation_with(user_role)
    paid_invoices_to(user_role).sum(:due_cents).to_i
  end

  def average_donation_with(user_role)
    return 0 unless paid_invoices_to(user_role).any?
    (total_donation_with(user_role)/paid_invoices_to(user_role).count)
  end

  ## Avg. Pledges
  def pledges_related_to(user_role)
    if self.is_a?(Sponsor)
      analytics_pledges.fundraiser(user_role)
    else
      analytics_pledges.sponsor(user_role)
    end
  end

  def average_pledge_with(user_role)
    return 0 unless pledges_related_to(user_role).any?
    (pledges_related_to(user_role).sum(&:total_amount_cents)/pledges_related_to(user_role).count) 
  end

  def average_donation_per_click_with(user_role)
    return 0 unless pledges_related_to(user_role).any?
    (pledges_related_to(user_role).sum(:amount_per_click_cents)/pledges_related_to(user_role).count)
  end

  ## Avg. Clicks
  def total_clicks_with(user_role)
    pledges_related_to(user_role).sum(:clicks_count).to_i
  end

  def average_clicks_per_pledge_with(user_role)
    return 0 unless pledges_related_to(user_role).any?
    (total_clicks_with(user_role)/pledges_related_to(user_role).count).floor
  end

  #### Invoices
  def outstanding_invoices
    invoices.outstanding.merge(pledges.past)
  end

  def past_invoices
    invoices.paid.merge(pledges.past)
  end

  #### Impressions
  ##General
  def pledge_views
    analytics_pledges.sum(:impressions_count).to_i
  end

  def campaign_views
    if self.is_a?(Sponsor)
      campaigns.merge(analytics_pledges).sum(:impressions_count).to_i
    else
      campaigns.not_pending.sum(:impressions_count).to_i
    end
  end

  def average_campaign_views
    if self.is_a?(Sponsor)
      return 0 if pledges_count.zero?
      (campaign_views/pledges_count).floor
    else
      return 0 if campaigns_count.zero?
      (campaign_views/campaigns_count).floor
    end
  end

  def average_pledge_views
    return 0 if pledges_count.zero?
    (pledge_views/pledges_count).floor
  end

  def average_engagement
    if self.is_a?(Sponsor)
      return 0 if pledge_views.zero?
      (total_clicks/pledge_views)
    else
      return 0 if campaign_views.zero?
      (total_clicks/campaign_views)
    end
  end

  ## Related
  def pledge_views_with(user_role)
    pledges_related_to(user_role).sum(:impressions_count).to_i
  end

  def average_pledge_views_with(user_role)
    return 0 unless pledges_related_to(user_role).any?
    (pledge_views_with(user_role)/pledges_related_to(user_role).count).floor
  end

  def average_engagement_with(user_role)
    return 0 if pledge_views_with(user_role).zero?
    (total_clicks_with(user_role)/pledge_views_with(user_role)).round
  end
end