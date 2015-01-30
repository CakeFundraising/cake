When(/^(?:I|they|he) (?:fill|fills) in the "(.*?)" field with (.*?)$/) do |field, value|
  fill_in field, with: value
end

When(/^(?:I|they|he) (?:fill|fills) in the appearing "(.*?)" field with (.*?)$/) do |field, value|
  if field == "Max value"
    first('.nested-fields .max_value').set(value)
  else
    first(:field, field).set(value) 
  end
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

When(/^(?:I|they|he) press the first "(.*?)" link$/) do |link|
  first(:link, link).click
end

When(/^(?:I|they|he) (?:select|selects) (.*?) in "(.*?)"$/) do |option, select_field|
  select(option, from: select_field)
end

When(/^(?:I|they|he) (?:check|checks) (.*?) from (.*?)$/) do |option, section|
  check(option)
end

When(/^he attachs an "(.*?)" image on the "(.*?)" field$/) do |image_type, field|
  within(:css, "##{field}") do
    attach_file('file', File.join(Rails.root, 'db/seeds/support/images/' + image_type + '.jpg') )
  end
end

#Messages & Locators
Then(/^(?:I|they|he) should see "(.*?)"$/) do |message|
  page.should have_content(message)
end

Then(/^he should see (?:a|an)?(\d+)? "(.*?)" button(?:s)?$/) do |quantity, button_name|
  page.should have_link(button_name, count: quantity)    
end

Then(/^show me the page$/) do
  save_and_open_page
end