Then(/^an invoice should be generated for that pledge$/) do
  invoice = @pledge.invoice
  invoice.should be_present
  invoice.clicks.should == @pledge.clicks_count
  invoice.click_donation.should == @pledge.amount_per_click
  invoice.due_cents.should == @pledge.amount_per_click_cents*@pledge.clicks_count
  invoice.status.should == 'due_to_pay'
end

#Fundraiser Billing
Given(/^(\d+) pending invoices from that fundraiser exist$/) do |quantity|
  pledge = FactoryGirl.create(:pledge, campaign: @past_campaigns.sample)
  @pending_invoices = FactoryGirl.create_list(:pending_invoice, 5, pledge: pledge)
end

Given(/^(\d+) past invoices from that fundraiser exist$/) do |quantity|
  pledge = FactoryGirl.create(:pledge, campaign: @past_campaigns.sample)
  @past_invoices = FactoryGirl.create_list(:invoice, 5, pledge: pledge)
end

Then(/^he should see his outstanding invoices$/) do
  within(:css, '#outstanding_invoices') do
    page.should have_selector('.invoice', count: @pending_invoices.count)
  end
end

Then(/^he should see his past invoices$/) do
  within(:css, '#past_invoices') do
    page.should have_selector('.invoice', count: @past_invoices.count)
  end
end