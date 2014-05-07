class PledgeDecorator < ApplicationDecorator
  delegate_all
  decorates_association :campaign
  decorates_association :sponsor
  decorates_association :fundraiser

  def end_date
    campaign.end_date
  end

  def causes
    object.campaign.causes
  end

  def scopes
    object.campaign.scopes
  end
end
