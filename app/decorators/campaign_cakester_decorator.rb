class CampaignCakesterDecorator < ApplicationDecorator
  delegate_all
  decorates_association :campaign

  delegate :fundraiser, :end_date, :main_cause, :scopes, to: :campaign

  def hero
    h.b campaign.hero
  end

  def rate
    "#{campaign.cakester_commission_percentage}%"
  end
end