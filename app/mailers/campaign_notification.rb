class CampaignNotification < ActionMailer::Base
  default from: "no-reply@cakefundraising.com"

  def campaign_ended(campaign, user)
    @campaign = campaign.decorate
    @receiver = user.decorate
    mail(to: @receiver.email, subject: 'Your campaign has ended.')
  end

  def campaign_launched(campaign, user)
    @campaign = campaign.decorate
    @receiver = user.decorate
    mail(to: @receiver.email, subject: 'Your pledged campaign has been launched!')
  end

  def fundraiser_missed_launch_date(campaign, user)
    @campaign = campaign.decorate
    @receiver = user.decorate
    mail(to: @receiver.email, subject: 'Your campaign has missed its launch date!')
  end

  def sponsor_missed_launch_date(campaign, user)
    @campaign = campaign.decorate
    @receiver = user.decorate
    mail(to: @receiver.email, subject: 'One of your pledged campaigns has missed its launch date!')
  end
end
