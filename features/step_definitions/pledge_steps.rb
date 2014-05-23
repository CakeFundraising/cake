Then(/^he should see the invitation link and badge$/) do
  find(:css, 'input#campaign_url').value.should == campaign_url(@campaign)
  find(:css, 'textarea#embedded_link')
end

Then(/^the page has the correct campaign selected$/) do
  find("#pledge_campaign_id option[value='#{@campaign.id}']").should be_selected
end

Then(/^he is taken to the new pledge page$/) do
  visit new_pledge_path(campaign: @campaign)
end

Given(/^the user is not registered as sponsor$/) do
end

Then(/^he creates a new sponsor account$/) do
  user = User.last
  sponsor = FactoryGirl.create(:sponsor)
  user.set_sponsor(sponsor)
end

When(/^he checks the "(.*?)" checkbox$/) do |field|
  check(field)
end

Then(/^he should see the Launch button and the pledge badge$/) do
  page.should have_content('Thank you for your Pledge!')
  page.should have_content('Launch and activate your pledge to ' + @pledge.campaign.title)
  find(:css, 'textarea#embedded_link')
  page.should have_link('Launch pledge')
end

Then(/^the pledge should be one of campaign's active pledges$/) do
  @campaign.pledges.active.should include(@pending_pledge)
end

Then(/^the pledge should not be present in the fundraiser pending pledges page$/) do
  visit path_to('fundraiser pending pledges page')
  page.should_not have_content(@pending_pledge.sponsor.name)
end

Then(/^a rejected flag should be present in the sponsor pledge requests page$/) do
  sign_out_user
  login_user(@pending_pledge.sponsor.manager)
  visit path_to('sponsor pledge requests page')
  page.should have_content('REJECTED')
end

#Pledge Click
When(/^he sees the click contribution modal$/) do
  within(:css, '#contribute_modal') do
    page.should have_content("Thanks for your support!")
  end
end

Then(/^he should see "(.*?)" in the click contribution modal$/) do |message|
  within(:css, '#contribute_modal') do
    page.should have_content(message)
  end
end

Then(/^the sponsor website should be open in a new window$/) do
  page.driver.browser.window_handles.size.should == 2
end

Then(/^a click should be added to the Pledge$/) do
  sleep 5
  Pledge.first.clicks_count.should == 1
end

Given(/^the user has already donated to that pledge$/) do
  ip_address = "253.187.158.63"
  @click = FactoryGirl.create(:click, pledge: model(:pledge), request_ip: ip_address)
  page.driver.options[:headers] = {'REMOTE_ADDR' => ip_address}
end

Then(/^the "(.*?)" link should not be present$/) do |link|
  page.should_not have_link(link)
end