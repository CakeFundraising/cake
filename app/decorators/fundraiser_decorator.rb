class FundraiserDecorator < ApplicationDecorator
  include AnalyticsDecorator
  delegate_all

  def to_s
    object.name    
  end  
  
  def causes
    object.causes.join(", ")
  end

  def cause
    object.causes.first
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
end