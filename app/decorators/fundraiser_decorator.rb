class FundraiserDecorator < ApplicationDecorator
  include AnalyticsDecorator
  delegate_all

  decorates_association :picture

  def to_s
    object.name    
  end  
  
  def causes
    object.causes.join(", ")
  end

  def cause
    object.causes.first
  end

  def min_pledge
    h.humanized_money_with_symbol object.min_pledge
  end

  def min_click_donation
    h.humanized_money_with_symbol object.min_click_donation
  end

  def website
    h.auto_attr_link website_url, target: :_blank
  end

  def website_url
    (object.website=~/^https?:\/\//).nil? ? "http://#{object.website}" : object.website
  end

  def email
    h.auto_mail object
  end

  ### Performance methods
  def active_campaigns_donation
    h.humanized_money_with_symbol object.active_campaigns_donation
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