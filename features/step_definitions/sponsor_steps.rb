Then(/^he should see his sponsor home dashboard$/) do
  page.should have_content(model(:sponsor).name)
  page.should have_content(model(:sponsor).manager_name)
  page.should have_content(model(:sponsor).manager_email)
  page.should have_link("Find a Cause to Sponsor")
  page.should have_link("Edit")
  page.should have_content("Unique Clicks from Active Pledges")
  page.should have_content("Global Sponsor Rank")
  page.should have_content("Total Donations")
end

Then(/^he should see his active pledges$/) do
  page.should have_selector('table#active_pledges tr.pledge', count: @pledges.count)
end

Then(/^he should see his pending pledge requests$/) do
  page.should have_selector('table#requested_pledges tr.pledge', count: @pledge_requests.count)
  page.should have_selector('table#sponsor_pledges tr.pledge', count: @pending_pledges.count)
end

Then(/^he should see his past pledges$/) do
  page.should have_selector('table#past_pledges tr.pledge', count: @past_pledges.count)
end

Then(/^he should see his past fundraisers$/) do
  @fundraisers = model(:sponsor).fundraisers_of(:past)
  page.should have_selector('table#fundraisers tr.fundraiser', count: @fundraisers.count)
end

#Credit card steps
Given(/^a stripe account for that sponsor exists?$/) do
  @stripe_account = FactoryGirl.create(:stripe_account, account: model(:sponsor))
end

Then(/^a credit card token should be stored in the sponsor's stripe account$/) do
  model(:sponsor).stripe_account.stripe_customer_id.should_not be_nil
end

Then(/^a credit card token should not be stored in the sponsor's stripe account$/) do
  model(:sponsor).stripe_account.stripe_customer_id.should be_nil
end