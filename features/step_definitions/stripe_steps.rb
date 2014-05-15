Then(/^he should see some information about his Stripe account$/) do
  page.should have_content(model(:fundraiser).stripe_account.uid)
end

Given(/^a consumer user$/) do
end