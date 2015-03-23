class CampaignCommissionDecorator < CampaignDecorator
  def rate
    "#{object.cakester_commission_percentage}%"
  end
end