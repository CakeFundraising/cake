Cake.bank_accounts ?= {}

Cake.bank_accounts.send_to_stripe = ->
  stripeResponseHandler = (status, response) ->
    if response.error
      $(".alert-danger").html response.error.message
      $(".alert-danger").removeClass "hidden"
    else
      token = response.id
      $("#bank_account_token").val token
      $("form.bank_account")[0].submit()
      $('form #bank_account_submit_action').val('Saving... Wait please')
    return

  $("form.bank_account").submit (e) ->
    if $(this).valid()
      e.preventDefault()
      routing = $("#bank_account_routing_number").val()
      account = $("#bank_account_account_number").val()
      Stripe.bankAccount.createToken
        country: "US"
        routingNumber: routing
        accountNumber: account
      , stripeResponseHandler
    return

  return

Cake.bank_accounts.validation = ->
  $('.formtastic.bank_account').validate(
    errorElement: "span"
    rules:
      'bank_account[name]': 
        required: true
      'bank_account[email]':
        required: true
        email: true
      'bank_account[type]':
        required: true
      'bank_account[tax_id]':
        required: true
        digits: true
        minlength: 9
        maxlength: 9
      'bank_account[routing_number]':
        required: true
        digits: true
        minlength: 9
        maxlength: 9
      'bank_account[account_number]':
        required: true
        digits: true
        minlength: 10
        maxlength: 12
  )
  return