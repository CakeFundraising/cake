When(/^he removes the (.*?) level$/) do |level|
  if level == 'Middle'
    page.find(:css, '.nested-fields[data-position="1"] a.remove_fields').click
  else
    page.find(:css, '.nested-fields[data-position="2"] a.remove_fields').click
  end
end

Then(/^(.*?) Level min value should be (\d+)$/) do |level, lowest_level_max_value|
  new_value = ActiveSupport::NumberHelper.number_to_currency (lowest_level_max_value.to_i + 1).floor, precision: 0

  expect(
    page.find(:css, '.nested-fields[data-position="1"] span.pledge-pad.min_value').text
  ).to eql(new_value)
end