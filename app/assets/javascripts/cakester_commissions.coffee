Cake.cakester_commissions ?= {}

dealTypeOnChange = (input_value)->
  flatInput = $('#cakester_commission_flat_input')
  percentageInput = $('#cakester_commission_percentage_input')
  inputsContainer = $('#deal_values')

  switch input_value
    when 'Probono'
      inputsContainer.hide()
    when 'Flat'
      inputsContainer.show()
      percentageInput.hide()
      flatInput.show()
    when 'Percentage'
      inputsContainer.show()
      percentageInput.show()
      flatInput.hide()
  return

dealValue = ->
  dealTypeInput = $('#cakester_commission_deal_type_input')

  dealTypeOnChange dealTypeInput.val()

  dealTypeInput.change ->
    dealTypeOnChange $(this).val()
    return
  return

validation = ->
  return

Cake.cakester_commissions.init = ->
  dealValue()
  #validation()
  return