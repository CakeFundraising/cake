When(/^the sponsor clicks on the invitation link to campaign$/) do
  visit new_pledge_path(campaign: model(:campaign))
end

Then(/^he is taken to the new pledge page$/) do
  visit new_pledge_path(campaign: model(:campaign))
end

Then(/^the sponsor should see the pledge wizard$/) do
  save_and_open_page
  page.should have_content("Your Pledge")
  find("#pledge_campaign_id option[value='#{model(:campaign).id}']").should be_selected
  page.should have_button("Agree & Continue")
end


Given(/^the user is not registered as sponsor$/) do
end

Then(/^he logs in$/) do
  login_user(@sponsor_user)
end

Then(/^he registers into the site$/) do
  @sponsor = FactoryGirl.create(:sponsor)
  @sponsor_user = FactoryGirl.create(:sponsor_user, sponsor: @sponsor)
  @sponsor.manager = @sponsor_user
  @sponsor.save
end