class SponsorDecorator < ApplicationDecorator
  include AnalyticsDecorator
  delegate_all

  decorates_association :picture

  def scopes
    object.scopes.join(", ")
  end

  def causes
    object.causes.join(", ")
  end

  def email
    h.auto_mail object
  end

  def website
    h.auto_attr_link website_url, target: :_blank unless object.website.blank?
  end

  def website_url
    (object.website=~/^https?:\/\//).nil? ? "http://#{object.website}" : object.website
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

  def subscriptors_count
    object.subscriptors.count
  end
end
