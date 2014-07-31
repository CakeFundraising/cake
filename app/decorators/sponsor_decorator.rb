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

  def total_donation
    "#{h.currency_symbol}#{h.number_to_human(object.total_donation, units: :numbers, format: '%n%u')}".html_safe
  end
end
