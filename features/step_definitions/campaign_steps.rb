Then(/^he should fill out the "Tell your story" form$/) do
  attrs = FactoryGirl.attributes_for :campaign

  fill_in("Title", with: attrs[:title])
  select(attrs[:causes].last, from: 'Causes')
  select(attrs[:scopes].last, from: 'Scopes')
  fill_in("Story", with: attrs[:story])
  fill_in("Headline", with: attrs[:headline])
  find(:css, "#campaign_launch_date").set(attrs[:launch_date])
  find(:css, "#campaign_end_date").set(attrs[:end_date])
  click_button("Save & Continue")
end
