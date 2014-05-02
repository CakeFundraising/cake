class CampaignNotification < ActionMailer::Base
  default from: "no-reply@cakefundraising.com"

  def campaign_ended(campaign)
    @campaign = campaign
    @receiver = campaign.fundraiser.manager
    mail(to: @receiver.email, subject: 'Your campaign has ended.')
  end
end
