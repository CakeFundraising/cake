class CampaignDecorator < ApplicationDecorator
  delegate_all
  decorates_association :video
  decorates_association :fundraiser

  def launch_date
    object.launch_date.strftime("%m/%d/%Y")
  end

  def end_date
    object.end_date.strftime("%m/%d/%Y")
  end

  def end_days
    object.end_date
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

  def raised
    h.humanized_money_with_symbol object.raised
  end

  def goal
    h.humanized_money_with_symbol object.goal
  end
end
