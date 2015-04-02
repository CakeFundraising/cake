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
  dealType = $('#cakester_commission_deal_type_input')
  flatInput = $('#cakester_commission_flat_input')
  percentageInput = $('#cakester_commission_percentage_input')
  inputsContainer = $('#deal_values')

  valid = true

  if dealType.length > 0
    if dealType.val() is 'Flat'
      if flatInput.val() is '0' or flatInput.val() is ''
        valid = false
        inputsContainer.find('.text-danger').remove()
        inputsContainer.append('<span class="text-danger">Please enter a value.</span>')
    if dealType.val() is 'Percentage'
      if percentageInput.val() is ''
        valid = false
        inputsContainer.find('.text-danger').remove()
        inputsContainer.append('<span class="text-danger">Please select a value.</span>')

  return valid

validateForm = ->
  submitButton = $('.formtastic.campaign input[type="submit"]')
  flatInput = $('#cakester_commission_flat_input')
  percentageInput = $('#cakester_commission_percentage_input')

  submitButton.click (e)->
    if validation()
      flatInput.remove() if flatInput.val() is '0' or flatInput.val() is ''
      percentageInput.remove() if percentageInput.val() is ''
    else
      e.preventDefault()
    return
  return

Cake.cakester_commissions.init = ->
  dealValue()
  validateForm()
  return