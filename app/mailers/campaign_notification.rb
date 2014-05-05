class CampaignNotification < ActionMailer::Base
  default from: "no-reply@cakefundraising.com"

  def campaign_ended(campaign, user)
    @campaign = campaign.decorate
    @receiver = user.decorate
    mail(to: @receiver.email, subject: 'Your campaign has ended.')
  end

  def missed_launch_date(campaign, user)
    @campaign = campaign.decorate
    @receiver = user.decorate
    mail(to: @receiver.email, subject: 'Your campaign has missed its launch date!')
  end
end
