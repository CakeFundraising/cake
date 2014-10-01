Given(/^(\d+) unsolicited pledges of his campaigns exist$/) do |quantity|
  @unsolicited_pledges = FactoryGirl.create_list(:pending_pledge, quantity.to_i, campaign: @campaigns.sample)
end

Given(/^(\d+) requested pledges of his campaigns exist$/) do |quantity|
  @requested_pledges = FactoryGirl.create_list(:pledge_request, quantity.to_i, campaign: @campaigns.sample, fundraiser: model(:fundraiser))
end

Then(/^he should see his fundraiser home dashboard$/) do
  page.should have_content(model(:fundraiser).name)
  page.should have_content(model(:fundraiser).manager_name)
  page.should have_content(model(:fundraiser).manager_email)
  page.should have_link("Start New Campaign")
  page.should have_link("Edit")
  page.should have_content("Donations Due From Active Campaigns")
  page.should have_content("Global Fundraiser Rank")
  page.should have_content("Total Number of Campaigns")
end

Then(/^he should see his active campaigns$/) do
  page.should have_selector('table#campaigns tr.campaign', count: @campaigns.count)
  page.should have_link("Start New Campaign")
end

Then(/^he should see his not launched campaigns$/) do
  page.should have_selector('#inactive table#campaigns tr.campaign', count: @not_launched_campaigns.count)
end

Then(/^he should see his unsolicited pledges$/) do
  page.should have_selector('table#unsolicited_pledges tr.pledge', count: @unsolicited_pledges.count)
end

Then(/^he should see his requested pledges$/) do
  page.should have_selector('table#requested_pledges tr.pledge', count: @requested_pledges.count)
end

Then(/^he should see his past campaigns$/) do
  page.should have_selector('table#campaigns tr.campaign', count: @past_campaigns.count)
end

Then(/^he should see his sponsors$/) do
  @sponsors = model(:fundraiser).sponsors
  page.should have_selector('table#sponsors tr.sponsor', count: @sponsors.count)
end

#Bank Account steps
Then(/^a bank account token should be stored in the fundraiser's stripe account$/) do
  model(:fundraiser).stripe_account.stripe_recipient_id.should_not be_nil
end

Then(/^a bank account token should not be stored in the fundraiser's stripe account$/) do
  model(:fundraiser).stripe_account.stripe_recipient_id.should be_nil
end