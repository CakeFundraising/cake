class PledgeDecorator < ApplicationDecorator
  delegate_all
  decorates_association :campaign
  decorates_association :sponsor
  decorates_association :coupons
  decorates_association :fundraiser
  decorates_association :video

  def to_s
    object.headline
  end

  def end_date
    campaign.end_date
  end

  def cause
    object.campaign.main_cause
  end

  def scopes
    object.campaign.scopes
  end
end
