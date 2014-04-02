Given(/^that (?:I|they) am not registered$/) do
  User.delete_all
end

When(/^(?:I|they) go to (.*?)$/) do |page_name|
  visit path_to(page_name)
end

When(/^(?:I|they) fill in "(.*?)" field with "(.*?)"$/) do |field, value|
  fill_in field, :with => value
end

When(/^(?:I|they) press the "(.*?)" button$/) do |button|
  click_button(button)
end

When(/^(?:I|they) press the "(.*?)" link$/) do |link|
  click_link(link)
end

Then(/^(?:I|they) should see "(.*?)"$/) do |message|
  page.should have_content(message)
end

Then(/^(?:I|they) should have (\d+) new user$/) do |ammount|
  User.count.should == ammount.to_i
end

#Oauth registration

When(/^(?:I|they) press the "(.*?)" link and allow the required permissions$/) do |link|
  click_link(link)
end

Then(/^(?:I|they) should be redirected to the new registration page$/) do
  visit new_user_registration_path
end

#User update
When(/^(?:I|they) select "(.*?)" in "(.*?)"$/) do |option, select_field|
  select option, :from => select_field
end

Given(/^that (?:I|they) am logged in as "(.*?)" with password "(.*?)"$/) do |email, password|
  @user = FactoryGirl.create(:user)
  visit new_user_session_path
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button("Sign in")
end

#Delete Account
Then(/^there shouldn't be registered users$/) do
  User.count.should == 0
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