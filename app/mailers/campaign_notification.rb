class CampaignNotification < AsyncMailer
  #include Roadie::Rails::Automatic

  #layout 'layouts/emails/application'

  default from: "no-reply@cakecausemarketing.com"

  def campaign_ended(campaign_id, user_id)
    @campaign = find_campaign(campaign_id).decorate
    @receiver = find_user(user_id).decorate
    mail(to: @receiver.email, subject: 'Your campaign has ended.')
  end

  def campaign_launched(campaign_id, user_id)
    @campaign = find_campaign(campaign_id).decorate
    @receiver = find_user(user_id).decorate
    mail(to: @receiver.email, subject: 'Your pledged campaign has been launched!')
  end

  def fundraiser_missed_launch_date(campaign_id, user_id)
    @campaign = find_campaign(campaign_id).decorate
    @receiver = find_user(user_id).decorate
    mail(to: @receiver.email, subject: 'Your campaign has missed its launch date!')
  end

  def sponsor_missed_launch_date(campaign_id, user_id)
    @campaign = find_campaign(campaign_id).decorate
    @receiver = find_user(user_id).decorate
    mail(to: @receiver.email, subject: 'One of your pledged campaigns has missed its launch date!')
  end

  protected

  def find_campaign(id)
    Campaign.find(id)
  end
end
