class CakesterDecorator < ApplicationDecorator
  delegate_all

  decorates_association :picture

  def to_s
    object.name
  end

  def scopes
    object.scopes.join(", ")
  end

  def causes
    object.causes.join(", ")
  end

  def email
    h.auto_mail object
  end

  def city_state
    [object.city, object.state_code, location.zip_code].join(', ')
  end

  def cause
    object.causes.first || '-'
  end

  def website
    h.auto_attr_link website_url, target: :_blank unless object.website.blank?
  end

  def website_url
    (object.website=~/^https?:\/\//).nil? ? "http://#{object.website}" : object.website
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

  def total_commissions
    h.humanized_money_with_symbol object.total_commissions
  end

  def average_pledge
    h.humanized_money_with_symbol object.average_pledge
  end

  def average_donation
    h.humanized_money_with_symbol object.average_donation
  end

  def average_commission
    h.humanized_money_with_symbol object.average_commission
  end
end
