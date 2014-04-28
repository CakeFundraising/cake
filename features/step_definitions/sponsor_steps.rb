Then(/^he should see his sponsor home dashboard$/) do
  page.should have_content(model(:sponsor).name)
  page.should have_content(model(:sponsor).manager_name)
  page.should have_content(model(:sponsor).manager_email)
  page.should have_link("Find a Cause to Sponsor")
  page.should have_link("Edit")
  page.should have_content("Clicks from Active Pledges")
  page.should have_content("Invoices Due")
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

Then(/^he should see his fundraisers$/) do
  @fundraisers = model(:sponsor).fundraisers
  page.should have_selector('table#fundraisers tr.fundraiser', count: @fundraisers.count)
end