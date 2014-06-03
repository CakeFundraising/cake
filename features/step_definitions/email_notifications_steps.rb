Given(/^the (.*?) user wants to receive notifications for "(.*?)"$/) do |user, event|
  if user == 'fundraiser'
    fundraiser_email_settings = I18n.t('activerecord.attributes.fundraiser_email_setting')
    model(user).manager.fundraiser_email_setting.update_attribute(fundraiser_email_settings.key(event), true)
  else
    sponsor_email_settings = I18n.t('activerecord.attributes.sponsor_email_setting')
    model(user).manager.sponsor_email_setting.update_attribute(sponsor_email_settings.key(event), true)
  end
end

Given(/^the (.*?) user doesn't want to receive notifications for "(.*?)"$/) do |user, event|
  if user == 'fundraiser'
    fundraiser_email_settings = I18n.t('activerecord.attributes.fundraiser_email_setting')
    model(user).manager.fundraiser_email_setting.update_attribute(fundraiser_email_settings.key(event), false)
  else
    sponsor_email_settings = I18n.t('activerecord.attributes.sponsor_email_setting')
    model(user).manager.sponsor_email_setting.update_attribute(sponsor_email_settings.key(event), false)
  end
end

#Sponsor givens
Given(/^the sponsor has pledged a campaign$/) do
  @pledge = FactoryGirl.create(:pledge, sponsor: model(:sponsor) )
  @campaign = @pledge.campaign
end

#FR events
When(/^the pledge is launched$/) do
  @pledge.launch!
end

When(/^the #{capture_model}(?:'s)? account information is changed$/) do |user|
  model(user).manager.update_attribute(:full_name, "New name")
end

When(/^the #{capture_model}(?:'s)? public profile is changed$/) do |user|
  model(user).update_attribute(:name, "New role name")
end

When(/^(?:the|his) campaign ends$/) do
  campaign = @campaign || model(:campaign)
  campaign.end
end

When(/^his campaign launch date is missed$/) do
  @campaign.missed_launch_date
end

#Sponsor events
When(/^a pledge request to that sponsor is made$/) do
  @pr = FactoryGirl.create(:pledge_request, sponsor: model(:sponsor) )
end

When(/^the pledge is (.*?) by the fundraiser$/) do |action|
  @pledge.send(action.gsub("ed", "!"))
end

When(/^his campaign is launched$/) do
  @campaign.launch!
end

When(/^the pledge campaign ends$/) do
  @pledge.campaign.end
end

When(/^the sponsor pays the invoice$/) do
  @payment = Payment.new_invoice({item_id: @pending_invoice.id, card_token: FactoryHelpers.stripe_card_token(Rails.configuration.stripe[:publishable_key])}, @pledge.sponsor)
  @payment.save
end