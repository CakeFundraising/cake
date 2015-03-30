Cake.direct_donation ?= {}

stripeCheckout = (key, image)->
  return StripeCheckout.configure(
    key: key
    image: image
    token: (token, args) ->
      $("#direct_donation_card_token").val token.id
      $("#direct_donation_email").val token.email
      $("#new_direct_donation").submit()
      return
  )

getAmount = ->
  return $("#direct_donation_amount").val()

Cake.direct_donation.donate = (fundraiser_name, key, image)->
  handler = stripeCheckout(key, image)
  
  $("#donate_button").off("click").click (e) ->
    e.preventDefault()

    amount = getAmount()

    if amount is "" or amount < 1
      alert "Please check your donation amount."
    else
      handler.open
        name: "Giving to"
        description: "#{fundraiser_name}"
        amount: amount * 100
    return
  return

amountButtons = ->
  buttons = $('#direct_donation_amount_input #donation-buttons button')
  input = $("#direct_donation_amount")

  buttons.click ->
    input.val($(this).data('value'))
    return
  return

Cake.direct_donation.init = ->
  amountButtons()
  return