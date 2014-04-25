# When(/^the sponsor clicks on the invitation link to campaign$/) do
#   visit new_pledge_path(campaign: model(:campaign))
# end

# Then(/^the sponsor should see the pledge wizard$/) do
#   page.should have_content("Your Pledge")
#   find("#pledge_campaign_id option[value='#{model(:campaign).id}']").should be_selected
#   page.should have_button("Agree & Continue")
# end


# Given(/^the user is not registered as sponsor$/) do
# end

# Then(/^he registers into the site$/) do
#   @sponsor = FactoryGirl.create(:sponsor)
#   @sponsor_user = FactoryGirl.create(:sponsor_user, sponsor: @sponsor)
#   @sponsor.manager = @sponsor_user
#   @sponsor.save
# end

When(/^he selects his campaign in the dropdown$/) do
  select(@campaign.title, from: 'Campaign')
end

Given(/^a pledge request from the fundraiser to the sponsor exists$/) do
  @pledge_request = FactoryGirl.create(:pledge_request, fundraiser: model(:fundraiser), sponsor: model(:sponsor), campaign: @campaign)
  sign_out_user
end

Then(/^he should see the pledge request listed$/) do
  find('#requested_pledges tr.pledge').should have_content(@pledge_request.campaign.title)
  find('#requested_pledges tr.pledge').should have_content(@pledge_request.fundraiser.name)
  find('#requested_pledges tr.pledge').should have_content(@pledge_request.campaign.causes.join(", "))
  find('#requested_pledges tr.pledge').should have_content(@pledge_request.campaign.scopes.join(", "))
end
