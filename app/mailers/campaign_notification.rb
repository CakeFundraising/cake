class CampaignNotification < ActionMailer::Base
  default from: "no-reply@cakefundraising.com"

  def campaign_ended(campaign, user)
    @campaign = campaign
    @receiver = user.decorate
    mail(to: @receiver.email, subject: 'Your campaign has ended.')
  end
end
