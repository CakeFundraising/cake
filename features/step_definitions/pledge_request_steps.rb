When(/^he selects his campaign in the dropdown$/) do
  select(@campaign.title, from: 'Campaign')
end

Given(/^a pledge request from the fundraiser to the sponsor exists$/) do
  @pledge_request = FactoryGirl.create(:pledge_request, fundraiser: model(:fundraiser), sponsor: model(:sponsor), campaign: @campaign)
  sign_out_user
end

Then(/^he should see the pledge request listed$/) do
  find('#requested_pledges tr.pledge').should have_content(@pledge_request.fundraiser.name)
  find('#requested_pledges tr.pledge').should have_content(@pledge_request.campaign.causes.join(", "))
  find('#requested_pledges tr.pledge').should have_content(@pledge_request.campaign.scopes.join(", "))
end