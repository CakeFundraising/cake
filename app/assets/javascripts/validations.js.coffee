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
  if Cake.campaigns.status or Cake.pledges.status
    object_status = (Cake.campaigns.status || Cake.pledges.status).capitalize()

  if object_status is 'Incomplete'
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

Cake.validations.init = ->
  Cake.validations.custom_methods()
  Cake.validations.form_leaving()

  Cake.users.validation()
  Cake.fundraisers.validation()
  Cake.sponsors.validation()
  
  Cake.campaigns.validation()
  Cake.pledges.validation()
  Cake.pledge_requests.validation()
  Cake.coupons.validation()

  Cake.bank_accounts.validation()
  Cake.credit_cards.validation()

  return