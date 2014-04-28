When(/^(?:I|they|he) (?:fill|fills) in the "(.*?)" field with (.*?)$/) do |field, value|
  fill_in field, with: value
end

When(/^(?:I|they|he) press the "(.*?)" button$/) do |button|
  click_button(button)
end

When(/^(?:I|they|he) press the "(.*?)" link$/) do |link|
  click_link(link)
end

Then(/^(?:I|they|he) should see "(.*?)"$/) do |message|
  page.should have_content(message)
end

When(/^(?:I|they|he) (?:select|selects) (.*?) in "(.*?)"$/) do |option, select_field|
  select(option, from: select_field)
end

When(/^he attachs an "(.*?)" image for the (.*?)$/) do |image_type, model|
  attach_file(model + '_picture_attributes_' + image_type, File.join(Rails.root, 'db/seeds/support/images/' + image_type + '.jpg') )
end