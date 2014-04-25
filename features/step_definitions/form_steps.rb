When(/^(?:I|they|he) (?:fill|fills) in "(.*?)" field with (.*?)$/) do |field, value|
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

#Upload Avatar
When(/^(?:I|they) attach a new (.+\.jpg)$/) do |image|
  attach_file('user_avatar', "#{Rails.root}/features/fixtures/#{image}")
  click_button('Update')
end

When(/^(?:I|they) attach a new (.+\.gif)$/) do |image|
  attach_file('user_avatar', "#{Rails.root}/features/fixtures/#{image}")
  click_button('Update')
end