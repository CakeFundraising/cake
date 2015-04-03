Cake.cakester_commissions ?= {}

class CakesterCommissionsForm
  constructor: ->
    @typeInput = $('#cakester_commission_deal_type_input')
    @inputsContainer = $('#deal_values')

    @flatInput = $('#cakester_commission_flat_input')
    @percentageInput = $('#cakester_commission_percentage_input')

    @flatInputContainer = @flatInput.closest('.input')
    @percentageInputContainer = @percentageInput.closest('.select')

    @probonoHelpText = $('span#probono')

    @submitButton = $('.formtastic.campaign input[type="submit"], .formtastic.cakester_request input[type="submit"]')
    return

  onChange: (value)->
    switch value
      when 'probono'
        @inputsContainer.hide()
        @probonoHelpText.show()
      when 'flat'
        @inputsContainer.show()
        @flatInputContainer.show()
        @percentageInputContainer.hide()
        @probonoHelpText.hide()
      when 'percentage'
        @inputsContainer.show()
        @percentageInputContainer.show()
        @flatInputContainer.hide()
        @probonoHelpText.hide()
    return

  valid: ->
    valid = true

    if @typeInput.length > 0

      if @typeInput.val() is 'Flat'
        if @flatInput.val() is '0' or @flatInput.val() is ''
          valid = false
          @inputsContainer.find('.text-danger').remove()
          @inputsContainer.append('<span class="text-danger">Please enter a value.</span>')

      if @typeInput.val() is 'Percentage'
        if @percentageInput.val() is ''
          valid = false
          @inputsContainer.find('.text-danger').remove()
          @inputsContainer.append('<span class="text-danger">Please select a value.</span>')

    return valid

  init: ->
    self = this

    @onChange @typeInput.val()

    @typeInput.change ->
      self.onChange $(this).val()

    @submitButton.click (e)->
      e.preventDefault() unless self.valid()
      return
    return

Cake.cakester_commissions.init = ->
  new CakesterCommissionsForm().init()
  return