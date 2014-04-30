# Routing
When(/^(?:I|they|he) (?:go|goes) to (.*?)$/) do |page_name|
  visit path_to(page_name)
end

When(/^(?:I|they|he) (?:visit|visits) the (.*?)$/) do |page_name|
  visit path_to(page_name)
end

When(/^(?:the|that|a) (?:fundraiser|sponsor) visits the (.*?)$/) do |page_name|
  visit path_to(page_name)
end

Then(/^(?:I|they|he) should be redirected to the new registration page as (.*?)$/) do |role|
  current_url.should == new_user_registration_url(role: role)
end

Then(/^(?:I|the|that|a|he)(?:fundraiser|sponsor)? should be taken to the (.*?)$/) do |page_name|
  current_path.should == path_to(page_name)
end

#Oauth registration
When(/^(?:I|they) press the "(.*?)" link and allow the required permissions$/) do |link|
  click_link(link)
end

# User Registration & Login
When(/^I click on the "Start Now" link$/) do
  first(:link, "Start Now").click
end

Given(/^that (?:I|they) am logged in as "(.*?)" with password "(.*?)"$/) do |email, password|
  visit new_user_session_path
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button("Sign in")
end

Given(/^that (.+) is logged in$/) do |role|
  user = model(role).manager
  login_user(user)
end

When(/^the user registers as a (.+)$/) do |role|
  send("register_#{role}")
end

When(/^he logs in$/) do
  login_user(@user)
end

# User states
Given(/^that (?:I|they) am not registered$/) do
  User.delete_all
end

Then(/^there shouldn't be registered users$/) do
  User.count.should == 0
end

Then(/^(?:I|they) should have (\d+) new user$/) do |ammount|
  User.count.should == ammount.to_i
end
