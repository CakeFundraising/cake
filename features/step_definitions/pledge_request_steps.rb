When(/^he selects his campaign in the dropdown$/) do
  select(@campaign.title, from: 'Campaign')
end

Given(/^a pledge request from the fundraiser to the sponsor exists$/) do
  @pledge_request = FactoryGirl.create(:pledge_request, fundraiser: model(:fundraiser), sponsor: model(:sponsor), campaign: @campaign)
  sign_out_user
end

Then(/^he should see the pledge request listed$/) do
  find('#requested_pledges tr.pledge').should have_content(@pledge_request.fundraiser.name)
  find('#requested_pledges tr.pledge').should have_content(@pledge_request.campaign.causes.first)
  find('#requested_pledges tr.pledge').should have_content(@pledge_request.campaign.scopes.first)
end

Then(/^the page has the correct campaign selected for that pledge request$/) do
  find("#pledge_campaign_id option[value='#{@pledge_request.campaign.id}']").should be_selected
end