When(/^he selects his campaign in the dropdown$/) do
  select(@campaign.title, from: 'Campaign')
end

Given(/^a pledge request from the fundraiser to the sponsor exists$/) do
  @pledge_request = FactoryGirl.create(:pledge_request, fundraiser: model(:fundraiser), sponsor: model(:sponsor), campaign: @campaign)
  sign_out_user
end

Then(/^he should see the pledge request listed$/) do
  find('#requested_pledges tr.pledge').should have_content(@pledge_request.fundraiser.name)
  find('#requested_pledges tr.pledge').should have_content(@pledge_request.campaign.main_cause)
  find('#requested_pledges tr.pledge').should have_content(@pledge_request.campaign.scopes.first)
end

Then(/^the page has the correct campaign selected for that pledge request$/) do
  find("#pledge_campaign_id", visible: false).value.to_i.should == @pledge_request.campaign.id
end

Then(/^a rejected flag should be present in the fundraiser pending pledges page$/) do
  sign_out_user
  login_user(@pledge_request.fundraiser.manager)
  visit path_to('fundraiser pending pledges page')
  page.should have_content('Rejected')
end
