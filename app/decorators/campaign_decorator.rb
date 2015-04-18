class CampaignDecorator < ApplicationDecorator
  include AnalyticsDecorator

  delegate_all
  decorates_association :video
  decorates_association :fundraiser
  decorates_association :picture
  decorates_association :sponsor_categories

  def class_name
    object.class.name
  end

  def instance_name
    class_name.downcase
  end

  def launch_date
    object.launch_date.strftime("%m/%d/%Y") if object.launch_date.present?
  end

  def end_date
    object.end_date.strftime("%m/%d/%Y") if object.end_date.present?
  end

  def end_date_countdown
    object.end_date.strftime("%Y/%m/%d %H:%M:%S")
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

  def total_donation_per_click
    h.humanized_money_with_symbol object.total_donation_per_click
  end

  def current_pledges_total
    h.humanized_money_with_symbol object.current_pledges_total
  end

  def current_average_donation
    h.humanized_money_with_symbol object.current_average_donation
  end

  def raised(status=:accepted)
    h.humanized_money_with_symbol object.raised(status)
  end

  def raised_by_status
    h.humanized_money_with_symbol object.raised_by_status
  end

  def goal
    h.humanized_money_with_symbol object.goal
  end

  def donations_raised
    h.humanized_money_with_symbol object.donations_raised
  end

  def status
    object.status.titleize
  end

  def pledges_count
    object.pledges.active.count + object.pledges.pending_or_past.count
  end

  def url_link
    h.auto_attr_link url, target: :_blank
  end

  def visitor_action
    return "Join, Sign Up or Volunteer!" if object.visitor_action.blank?
    object.visitor_action
  end

  def url
    unless object.url.blank?
      (object.url=~/^https?:\/\//).nil? ? "http://#{object.url}" : object.url
    end
  end
end
