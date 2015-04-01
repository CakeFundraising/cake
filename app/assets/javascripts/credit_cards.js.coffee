Cake.credit_cards.send_to_stripe = ->
  stripeResponseHandler = (status, response) ->
    if response.error
      $(".alert-danger").html response.error.message
      $(".alert-danger").removeClass "hidden"
    else
      token = response.id
      $("#credit_card_token").val token
      $("form.credit_card")[0].submit()
      $('form #credit_card_submit_action').val('Saving... Wait please')
    return

  $("form.credit_card").submit (e) ->
    if $(this).valid()
      e.preventDefault()
      Stripe.card.createToken
        number: $("#credit_card_number").val()
        cvc: $("#credit_card_cvc").val()
        exp_month: $("#credit_card_exp_month").val()
        exp_year: $("#credit_card_exp_year").val()
      , stripeResponseHandler
    return

  return

Cake.credit_cards.validation = ->
  $('.formtastic.credit_card').validate(
    errorElement: "span"
    rules:
      'credit_card[number]': 
        required: true
        digits: true
        minlength: 13
        maxlength: 16
      'credit_card[cvc]':
        required: true
        digits: true
        minlength: 3
        maxlength: 4
      'credit_card[exp_month]':
        required: true
      'credit_card[exp_year]':
        required: true
  )
  return