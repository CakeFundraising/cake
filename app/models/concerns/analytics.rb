module Analytics
  extend ActiveSupport::Concern

  included do
    alias_method :total_raised, :total_donation
  end

  def total_donation
    invoices.paid.sum(:due_cents).to_i
  end

  def total_clicks
    pledges.accepted_or_past.sum(:clicks_count).to_i
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
    pledges.accepted_or_past.any?
  end

  def pledges_count
    pledges.accepted_or_past.count
  end

  def average_pledge
    return 0 unless any_pledges?
    (pledges.accepted_or_past.to_a.sum(&:total_amount_cents)/pledges_count) 
  end

  def average_donation
    return 0 unless invoices.paid.any?
    (total_donation/invoices.paid.count)
  end

  def average_donation_per_click
    return 0 unless any_pledges?
    (pledges.accepted_or_past.sum(:amount_per_click_cents)/pledges_count)
  end

  def average_clicks_per_pledge
    return 0 unless any_pledges?
    (total_clicks/pledges_count).floor
  end

  def top_pledges(limiter)
    pledges.accepted_or_past.highest.first(limiter)
  end

  def top_causes # {cause_name: pledge_amount}
    top_causes = {}
    top_pledges(3).each do |pledge|
      top_causes.store(pledge.main_cause, pledge.total_amount) unless top_causes.has_key?(pledge.main_cause)
    end
    top_causes
  end

  def invoices_due
    outstanding_invoices.sum(:due_cents).to_i
  end

  #### Invoices
  def outstanding_invoices
    invoices.outstanding.merge(pledges.past)
  end

  def past_invoices
    invoices.paid.merge(pledges.past)
  end
end