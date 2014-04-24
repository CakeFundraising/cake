Then(/^he should see his sponsor home dashboard$/) do
  page.should have_content(model(:sponsor).name)
  page.should have_content(model(:sponsor).manager_name)
  page.should have_content(model(:sponsor).manager_email)
  page.should have_link("Find a Cause to Sponsor")
  page.should have_link("Edit")
  page.should have_content("Clicks from Active Pledges")
  page.should have_content("Invoices Due")
end