Given(/^the (.*?) manager wants to receive notifications for "(.*?)"$/) do |user, event|
  if user == 'fundraiser'
    fundraiser_email_settings = I18n.t('activerecord.attributes.fundraiser_email_setting')
    model(user).manager.fundraiser_email_setting.update_attribute(fundraiser_email_settings.key(event), true)
  else
    sponsor_email_settings = I18n.t('activerecord.attributes.sponsor_email_setting')
    model(user).manager.sponsor_email_setting.update_attribute(sponsor_email_settings.key(event), true)
  end
end

Given(/^the (.*?) manager doesn't want to receive notifications for "(.*?)"$/) do |user, event|
  if user == 'fundraiser'
    fundraiser_email_settings = I18n.t('activerecord.attributes.fundraiser_email_setting')
    model(user).manager.fundraiser_email_setting.update_attribute(fundraiser_email_settings.key(event), false)
  else
    sponsor_email_settings = I18n.t('activerecord.attributes.sponsor_email_setting')
    model(user).manager.sponsor_email_setting.update_attribute(sponsor_email_settings.key(event), false)
  end
end

When(/^the pledge is launched$/) do
  @pledge.launch!
end

When(/^the #{capture_model}(?:'s)? account information is changed$/) do |user|
  model(user).manager.update_attribute(:full_name, "New name")
end

When(/^the #{capture_model}(?:'s)? public profile is changed$/) do |user|
  model(user).update_attribute(:name, "New role name")
end

When(/^his campaign ends$/) do
  @campaign.end!
end