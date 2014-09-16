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
  model_name = form.attr('class').replace('formtastic ', '')
  object_id = form.attr('action').split('/')[2]
  message = 'This ' + model_name + " will be cancelled. Please complete the form and press 'SAVE & CONTINUE' to continue."

  form_invalid = (e)->
    eval("Cake."+ model_name + "s.validation()")
    e.preventDefault() unless form.valid()
    return !form.valid()

  delete_object = ->
    $('#hidden_delete_link').click()
    return

  if pages.length > 0
    #Turbolinks
    $(document).on "page:before-change", (e)->
      r = confirm(message) if form_invalid(e)
      delete_object() if r
      return
    #Normal links
    $('a[data-no-turbolink="true"]').click (e)->
      r = confirm(message) if form_invalid(e)
      delete_object() if r
      return
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