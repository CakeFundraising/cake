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

Cake.validations.init = ->
  Cake.validations.custom_methods()

  Cake.users.validation()
  Cake.fundraisers.validation()
  Cake.sponsors.validation()
  
  Cake.campaigns.validation()
  Cake.pledges.validation()
  Cake.coupons.validation()

  Cake.bank_accounts.validation()
  Cake.credit_cards.validation()

  return