When(/^he removes the (.*?) level$/) do |level|
  if level == 'Middle'
    page.find(:css, '.nested-fields[data-position="1"] a.remove_fields').click
  else
    page.find(:css, '.nested-fields[data-position="2"] a.remove_fields').click
  end
end

Then(/^(.*?) Level min value should be (\d+)$/) do |level, lowest_level_max_value|
  lowest_level_max_value_cents = (lowest_level_max_value.to_i + 1)*100
  
  page_money = Money.parse( page.find(:css, '.nested-fields[data-position="1"] span.pledge-pad.min_value').text )
  expected_money = Money.new(lowest_level_max_value_cents, "USD")

  expect(page_money).to eql(expected_money)
end