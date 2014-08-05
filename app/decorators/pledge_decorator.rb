class PledgeDecorator < ApplicationDecorator
  delegate_all
  decorates_association :campaign
  decorates_association :invoice
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

  def total_amount
    h.humanized_money_with_symbol object.total_amount
  end

  def amount_per_click
    h.humanized_money_with_symbol object.amount_per_click
  end

  def fundraiser_name(length)
    h.truncate(object.fundraiser.name, length: 36)
  end

  def sponsor_name(length)
    h.truncate(object.sponsor.name, length: 36)
  end
end
