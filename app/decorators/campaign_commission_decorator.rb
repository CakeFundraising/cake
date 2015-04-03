class CampaignCommissionDecorator < CampaignDecorator
  def rate
    commission_settings = object.cakester_commission_setting

    case commission_settings.deal_type
    when 'probono'
      rate = 'Pro Bono'
    when 'flat'
      rate = h.humanized_money_with_symbol commission_settings.flat_value
    else #Percentage
      rate = "#{commission_settings.percentage_value}%"
    end
    
    rate    
  end
end