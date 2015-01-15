Cake.validations ?= {}

Cake.validations.custom_methods = ->
  $.validator.addMethod "onlyletters", ((value, element, params) ->
    this.optional(element) || /^[a-z\s]+$/i.test(value)
  ), (params, element) ->
    "Please enter only letters."

  $.validator.addMethod "url", ((value, element, params) ->
    this.optional(element) || /^(?:(?:https?|ftp):\/\/)?(?:\S+(?::\S*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/\S*)?$/i.test(value)
  ), (params, element) ->
    "Please enter a valid URL."

  $.validator.addMethod "minStrictPledgeLevels", ((value, element, params) ->
    min = $(element).closest('.pledge_level').find('.min_value').text().replace('$','').replace(',', '')
    this.optional(element) || parseInt(value) > parseInt(min)
  ), (params, element) ->
    min = $(element).closest('.pledge_level').find('.min_value').text().replace('$','')
    "Please enter a value greater than $" + min

  $.validator.addMethod "limitToIntegerRange", ((value, element, params) ->
    this.optional(element) || parseInt(value) < 9999999999
  ), (params, element) ->
    "Please enter a value smaller than $9999999999"

  $.validator.addMethod "minStrict", ((value, element, params) ->
    this.optional(element) || parseInt(value) > parseInt(params)
  ), jQuery.validator.format("Please enter a value greater than {0}")

  return

Cake.validations.form_leaving = ->
  if Cake.campaigns.status or Cake.pledges.status
    object_status = (Cake.campaigns.status || Cake.pledges.status).capitalize()

    form = $('.formtastic.pledge, .formtastic.campaign')

    if form.length > 0
      model_name = form.attr('class').replace('formtastic ', '')

      form_invalid = ->
        eval("Cake."+ model_name + "s.validation()")
        return !form.valid()

  if object_status is 'Incomplete' and form_invalid()
    message = "Are you sure you want to leave? \n Your changes will not be saved."

    delete_object = ->
      $('#hidden_delete_link').click()
      return

    show_message = ->
      r = confirm(message)
      delete_object() if r
      return

    #Turbolinks
    $(document).on "page:before-change", (e)->
      e.preventDefault()
      show_message()
      return
    #Normal links
    $('a[data-no-turbolink="true"]').click (e)->
      e.preventDefault()
      show_message()
      return
  return

Cake.validations.require_form = (model)->
  form = $('.formtastic.' + model)
  eval("Cake."+ model + "s.validation()")

  show_message = (e)->
    r = confirm 'Are you sure you want to navigate away from this page?'
    if r
      window.onbeforeunload = null
      $(document).off "page:before-change"
    else
      e.preventDefault()
    return

  unless form.valid()
    #Turbolinks
    $(document).on "page:before-change", (e)->
      show_message(e)
      return
    #Normal links
    $('a[data-no-turbolink="true"]').click (e)->
      show_message(e)
      return
    #Search form
    $('.form-search').submit (e)->
      show_message(e)
      return
    #Page leaving
    window.onbeforeunload = ->
      return 'Your changes are not saved yet.'
  return

Cake.validations.init = ->
  Cake.validations.custom_methods()
  Cake.validations.form_leaving()

  Cake.users.validation()
  Cake.fundraisers.validation()
  Cake.sponsors.validation()

  Cake.fr_sponsors.validation()
  
  Cake.campaigns.validation()
  Cake.pledges.validation()
  Cake.pledge_requests.validation()
  Cake.coupons.validation()

  Cake.bank_accounts.validation()
  Cake.credit_cards.validation()

  Cake.pictures.validation.init()
  Cake.pictures.validation.coupons()
  Cake.quick_pledges.validation()

  Cake.mailers.contact_validation()
  return