class SponsorDecorator < ApplicationDecorator
  delegate_all

  def scopes
    object.scopes.join(", ")
  end

  def website
    "http://#{object.website}"
  end

  def to_s
    object.name
  end

  def stripe_customer?
    stripe_account.present? and stripe_account.customer?
  end

  ### Performance methods
  def total_donation
    "#{h.currency_symbol}#{h.number_to_human(object.total_donation/100, units: :numbers, format: '%n%u')}".html_safe
  end

  def average_pledge
    h.humanized_money_with_symbol object.average_pledge/100
  end

  def average_donation_per_click
    h.humanized_money_with_symbol object.average_donation_per_click/100
  end

  def average_donation
    h.humanized_money_with_symbol object.average_donation/100
  end

  def invoices_due
    h.humanized_money_with_symbol object.invoices_due/100
  end

  def rank
    "##{object.rank}"
  end

  def local_rank
    "##{object.local_rank}"
  end

  #Top causes
  def top_cause_name(index)
    object.top_causes.keys[index]
  end

  def top_cause_amount(index)
    object.top_causes.values[index]
  end

  def top_cause_amount_percentile(index)
    value = top_cause_amount(index)
    top_value = top_cause_amount(0)

    (value/top_value)*100 unless value.nil? or top_value.nil?
  end

  # Analytics related to FR
  def average_donation_with(fr)
    h.humanized_money_with_symbol object.average_donation_with(fr)/100
  end

  def average_pledge_with(fr)
    h.humanized_money_with_symbol object.average_pledge_with(fr)/100
  end

  def average_donation_per_click_with(fr)
    h.humanized_money_with_symbol object.average_donation_per_click_with(fr)/100
  end
end
