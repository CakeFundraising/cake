class QuickPledgeDecorator < ApplicationDecorator
  delegate_all
  decorates_association :campaign
  decorates_association :picture

  def to_s
    object.name
  end

  def end_date
    campaign.end_date
  end

  def total_amount
    h.humanized_money_with_symbol object.total_amount
  end

  def donation_per_click
    h.humanized_money_with_symbol object.donation_per_click
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
end
