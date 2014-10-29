Cake.direct_donation = (campaign_name, key, image)->
  handler = StripeCheckout.configure(
    key: key
    image: image
    token: (token, args) ->
      $("#direct_donation_card_token").val token.id
      $("#direct_donation_email").val token.email
      $("#new_direct_donation").submit()
      return
  )
  
  $("#donate_button").off("click").click (e) ->
    e.preventDefault()
    amount = $("#direct_donation_amount").val()

    if amount is "" or amount < 1
      $("#direct_donation_amount_input").addClass "has-error"
      alert "Please check your donation amount."
    else
      $("#direct_donation_amount_input").removeClass "has-error"
      handler.open
        name: "Make a Direct Donation"
        description: 'To #{campaign_name}'
        amount: amount * 100
    return

  return