When(/^(?:I|they|he) (?:fill|fills) in the "(.*?)" field with (.*?)$/) do |field, value|
  fill_in field, with: value
end

When(/^(?:I|they|he) press the "(.*?)" button$/) do |button|
  first(:button, button).click
end

When(/^he finds and press the "(.*?)" button$/) do |button|
  first(button).click
end

When(/^(?:I|they|he) press the "(.*?)" link$/) do |link|
  click_link(link)
end

When(/^(?:I|they|he) (?:select|selects) (.*?) in "(.*?)"$/) do |option, select_field|
  select(option, from: select_field)
end

When(/^(?:I|they|he) (?:check|checks) (.*?) from the Types of Campaigns options$/) do |option|
  check(option)
end

When(/^he attachs an "(.*?)" image on the "(.*?)" field$/) do |image_type, field|
  attach_file(field, File.join(Rails.root, 'db/seeds/support/images/' + image_type + '.jpg') )
end

#Messages & Locators
Then(/^(?:I|they|he) should see "(.*?)"$/) do |message|
  page.should have_content(message)
end

Then(/^he should see (?:a|an)?(\d+)? "(.*?)" button(?:s)?$/) do |quantity, button_name|
  page.should have_link(button_name, count: quantity)    
end
