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

When(/^he selects (.*?) in "(.*?)"$/) do |option, select|
  select(option, from: select)
end
