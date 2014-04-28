class PledgeDecorator < ApplicationDecorator
  delegate_all
  decorates_association :campaign
  decorates_association :sponsor
  decorates_association :fundraiser

  def start_end_dates
    "#{campaign.launch_date} to #{campaign.end_date}"
  end
end
