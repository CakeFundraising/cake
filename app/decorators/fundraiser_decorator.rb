class FundraiserDecorator < ApplicationDecorator
  include AnalyticsDecorator
  delegate_all

  def to_s
    object.name    
  end  
  
  def causes
    object.causes.join(", ")
  end

  ### Performance methods
  def active_campaigns_donation
    h.humanized_money_with_symbol object.active_campaigns_donation
  end
end