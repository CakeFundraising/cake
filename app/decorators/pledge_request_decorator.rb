class PledgeRequestDecorator < ApplicationDecorator
  delegate_all
  decorates_association :campaign
  decorates_association :sponsor
  decorates_association :fundraiser

  def start_end_dates
    "#{object.campaign.launch_date} to #{object.campaign.end_date}"
  end
end
