Given(/^a campaign of that fundraiser exists$/) do
  @campaign = FactoryGirl.create(:campaign, fundraiser: model(:fundraiser))
end