class PledgeRequestDecorator < ApplicationDecorator
  delegate_all
  decorates_association :campaign
  decorates_association :sponsor
  decorates_association :fundraiser
  decorates_association :requester
  decorates_association :pledge

  def start_end_dates
    "#{campaign.launch_date} to #{campaign.end_date}"
  end

  def cause
    object.campaign.main_cause
  end

  def scopes
    object.campaign.scopes
  end

  def status
    object.status.upcase
  end
end
