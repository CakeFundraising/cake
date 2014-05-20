Then(/^an invoice should be generated for that pledge$/) do
  invoice = @pledge.invoice
  invoice.should be_present
  invoice.clicks.should == @pledge.clicks_count
  invoice.click_donation.should == @pledge.amount_per_click
  invoice.due_cents.should == @pledge.amount_per_click_cents*@pledge.clicks_count
  invoice.status.should == 'due_to_pay'
end
