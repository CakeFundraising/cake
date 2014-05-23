Then(/^he should see some information about his Stripe account$/) do
  page.should have_content(model(:fundraiser).stripe_account.uid)
end

Given(/^a consumer user$/) do
end

When(/^he sees the Stripe Checkout popup$/) do
  page.should have_selector('.stripe_checkout_app') 
end

When(/^he fills in the popup "(.*?)" field with "(.*?)"$/) do |field, value|
  within_frame("stripe_checkout_app") do
    fill_in field, with: value
  end
end

When(/^he press the "(.*?)" button within the popup$/) do |button|
  within_frame("stripe_checkout_app") do
    find('button[type="submit"]').click
  end
  WebMock.disable!
  sleep 10
end

Then(/^the campaign should have a new direct donation of (\d+) dollars$/) do |amount|
  direct_donations = @campaign.direct_donations
  direct_donations.count.should == 1

  @direct_donation = direct_donations.first
  @direct_donation.amount_cents.should == amount.to_i*100
end

Then(/^a charge of (\d+) dollars should be done to the credit card$/) do |amount|
  @direct_donation.charge.resource.amount.should == amount.to_i*100
  WebMock.enable!
end

#Invoice payment
Given(/^an invoice for that pledge exists$/) do
  @invoice = FactoryGirl.create(:pending_invoice, pledge: @past_pledge)
end
