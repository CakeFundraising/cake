Given(/^a campaign of that fundraiser exists$/) do
  @campaign = FactoryGirl.create(:campaign, fundraiser: model(:fundraiser))
end

Then(/^he should see the invitation link and badge$/) do
  page.should have_content("Copy the link to invite sponsors to pledge")
  find(:css, 'input#campaign_url').value.should == campaign_url(@campaign)
  find(:css, 'textarea#embedded_link')
end

Then(/^the page has the correct campaign selected$/) do
  find("#pledge_campaign_id option[value='#{@campaign.id}']").should be_selected
end

Then(/^he is taken to the new pledge page$/) do
  visit new_pledge_path(campaign: @campaign)
end