class PledgeDecorator < ApplicationDecorator
  delegate_all
  decorates_association :campaign
  decorates_association :invoice
  decorates_association :sponsor
  decorates_association :fundraiser
  decorates_association :video
  decorates_association :picture
  
  def to_s
    object.name
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

  def scope
    scopes.first
  end

  def total_amount
    h.humanized_money_with_symbol object.total_amount
  end

  def amount_per_click
    h.humanized_money_with_symbol object.amount_per_click
  end

  def total_charge
    h.humanized_money_with_symbol object.total_charge
  end

  def fundraiser_name(length)
    h.truncate(object.fundraiser.name, length: 36)
  end

  def sponsor_name(length)
    h.truncate(object.sponsor.name, length: 36)
  end

  def status
    object.status.titleize
  end

  def website
    h.auto_attr_link website_url, target: :_blank
  end

  def website_url
    (object.website_url=~/^https?:\/\//).nil? ? "http://#{object.website_url}" : object.website_url
  end

  ##impressions
  def engagement
    "#{object.engagement}%"
  end
end
