class SponsorDecorator < ApplicationDecorator
  include AnalyticsDecorator
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

  def phone
    h.number_to_phone(object.phone, area_code: true)
  end

  def manager_phone
    h.number_to_phone(object.manager_phone, area_code: true)
  end
end
