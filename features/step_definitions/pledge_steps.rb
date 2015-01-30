Then(/^he should see the invitation link and badge$/) do
  find(:css, 'input#campaign_url').value.should == campaign_url(@campaign)
  find(:css, 'textarea#embedded_link')
end

Then(/^the page has the correct campaign selected$/) do
  find("#pledge_campaign_id", visible: false).value.to_i.should == @campaign.id
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
  page.should have_content('Rejected')
end

Given(/^a pledge request related to that pledge exists$/) do
  @pledge_request = FactoryGirl.create(:pledge_request, sponsor: @pending_pledge.sponsor, fundraiser: @pending_pledge.fundraiser, campaign: @pending_pledge.campaign)
end

Then(/^it should delete the related pledge request$/) do
  PledgeRequest.exists?(@pledge_request.id).should be_false
end

#Pledge Click
When(/^he press the click button$/) do
  find(:css, '.no_browser_link').click
  find(:css, '.click_link').click
end

When(/^he sees the click contribution modal$/) do
  within(:css, '#click_counted') do
    page.should have_content("Thanks for your support!")
  end
end

Given(/^the pledge is fully subscribed$/) do
  FactoryGirl.create_list(:click, model(:pledge).max_clicks - 1, pledge: model(:pledge) )
end

Then(/^he should see "(.*?)" in the click contribution modal$/) do |message|
  within(:css, '#click_counted') do
    page.should have_content(message)
  end
end

Then(/^the sponsor website should be open in a new window$/) do
  page.driver.browser.window_handles.size.should == 2
end

Then(/^a click should be added to the Pledge$/) do
  sleep 5
  Pledge.first.clicks.count.should == 1
end

Given(/^the user has already donated to that pledge$/) do
  browser = FactoryGirl.create(:firefox_browser, ip: "127.0.0.1", ua: page.driver.execute_script('return navigator.userAgent;') )
  @click = FactoryGirl.create(:firefox_click, pledge: model(:pledge), browser: browser)
end

Then(/^the "(.*?)" link should not be present$/) do |link|
  page.should_not have_link(link)
end

#Increase request
Then(/^an increase request should be stored in the pledge$/) do
  @pledge.reload.increase_requested.should be_true
end
