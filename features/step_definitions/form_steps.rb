When(/^(?:I|they|he) (?:fill|fills) in the "(.*?)" field with (.*?)$/) do |field, value|
  fill_in field, with: value
end

When(/^(?:I|they|he) press the "(.*?)" button$/) do |button|
  click_button(button)
end

When(/^(?:I|they|he) press the "(.*?)" link$/) do |link|
  click_link(link)
end

When(/^(?:I|they|he) (?:select|selects) (.*?) in "(.*?)"$/) do |option, select_field|
  select(option, from: select_field)
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
