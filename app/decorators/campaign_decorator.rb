class CampaignDecorator < ApplicationDecorator
  delegate_all
  decorates_association :video

  def launch_date
    object.launch_date.strftime("%B %d, %Y")
  end

  def end_date
    object.end_date.strftime("%B %d, %Y")
  end
end
