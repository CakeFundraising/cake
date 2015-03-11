class CampaignCakesterDecorator < ApplicationDecorator
  delegate_all
  decorates_association :campaign
  decorates_association :cakester

  delegate :fundraiser, :end_date, :main_cause, :scopes, to: :campaign

  def hero
    h.b campaign.hero
  end

  def kind
    object.kind.titleize
  end

  def rate
    "#{campaign.cakester_commission_percentage}%"
  end

  def pledge
    #object.pledge || '-'
    '-'
  end

  def status
    (object.status || 'Accepted').titleize
  end
end