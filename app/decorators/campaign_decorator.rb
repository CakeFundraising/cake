class CampaignDecorator < ApplicationDecorator
  delegate_all
  decorates_association :video
  decorates_association :fundraiser
  decorates_association :sponsor_categories

  def launch_date
    object.launch_date.strftime("%m/%d/%Y") if object.launch_date.present?
  end

  def end_date
    object.end_date.strftime("%m/%d/%Y") if object.end_date.present?
  end

  def end_date_countdown
    object.end_date.strftime("%Y/%m/%d")
  end

  def start_end_dates
    "#{launch_date} to #{end_date}"
  end

  def to_s
    object.title
  end

  def causes
    object.causes.join(", ")
  end

  def scopes
    object.scopes.join(", ")
  end

  def current_pledges_total
    h.humanized_money_with_symbol object.current_pledges_total
  end

  def raised
    h.humanized_money_with_symbol object.raised
  end

  def goal
    h.humanized_money_with_symbol object.goal
  end
end
