Given(/^a campaign exists of that fundraiser$/) do
  @campaign = FactoryGirl.create(:campaign, fundraiser: model(:fundraiser))
end

Then(/^he should see the invitation link and badge$/) do
  page.should have_content("Copy the link to invite sponsors to pledge")
  find(:css, 'input#campaign_url').value.should == campaign_url(@campaign)
  find(:css, 'textarea#embedded_link')
end