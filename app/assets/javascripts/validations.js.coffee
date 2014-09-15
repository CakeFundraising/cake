Cake.validations ?= {}

Cake.validations.custom_methods = ->
  $.validator.addMethod "onlyletters", ((value, element, params) ->
    this.optional(element) || /^[a-z\s]+$/i.test(value)
  ), (params, element) ->
    "Please enter only letters."

  $.validator.addMethod "minStrictPledgeLevels", ((value, element, params) ->
    min = $(element).closest('.pledge_level').find('.min_value').text().replace('$','').replace(',', '')
    this.optional(element) || parseInt(value) > parseInt(min)
  ), (params, element) ->
    min = $(element).closest('.pledge_level').find('.min_value').text().replace('$','')
    "Please enter a value greater than $" + min

  $.validator.addMethod "minStrict", ((value, element, params) ->
    this.optional(element) || parseInt(value) > parseInt(params)
  ), jQuery.validator.format("Please enter a value greater than {0}")
    
  return

Cake.validations.form_leaving = ->
  pages = $('#story.tab-pane.active')
  form = $('.formtastic.pledge, .formtastic.campaign')
  model_name = form.attr('class').replace('formtastic ', '') + "s"

  validate = (e, event)->
    eval("Cake."+ model_name + ".validation()")

    if form.valid()
      return false
    else  
      e.preventDefault()
      return 'Looks like this form is not correct, please check out all fields and press "SAVE & CONTINUE" before continuing.'
    return

  if pages.length > 0
    $(document).on "page:before-change", (e)->
      alert validate(e) if validate(e)
      return
    $(window).on 'beforeunload', (e)->
      confirmationMessage = validate(e)
      if confirmationMessage
        (e or window.event).returnValue = confirmationMessage #Gecko + IE
        return confirmationMessage
  return

Cake.validations.init = ->
  Cake.validations.custom_methods()
  Cake.validations.form_leaving()

  Cake.users.validation()
  Cake.fundraisers.validation()
  Cake.sponsors.validation()
  
  Cake.campaigns.validation()
  Cake.pledges.validation()
  Cake.coupons.validation()

  Cake.bank_accounts.validation()
  Cake.credit_cards.validation()

  return