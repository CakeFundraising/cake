class DirectDonation
  constructor: (fundraiser_name, key, image) ->
    @fundraiser = fundraiser_name
    @stripeHandler = @stripeCheckout(key, image)
    @amountInput = $("#direct_donation_amount")

    @amountButtons()
    @otherAmountInput()
    return

  stripeCheckout: (key, image)->
    return StripeCheckout.configure(
      key: key
      image: image
      token: (token, args) ->
        $("#direct_donation_card_token").val token.id
        $("#direct_donation_email").val token.email
        $("#new_direct_donation").submit()
        return
    )

  openStripe: (amount)->
    @stripeHandler.open
      name: "Giving to"
      description: "#{@fundraiser}"
      amount: amount * 100
    return

  setAmountOnForm: (amount)->
    @amountInput.val(amount)
    return

  amountButtons: ->
    buttons = $('#direct_donation_amount_input #donation-buttons button.fixed-amount')

    self = this
    buttons.click ->
      amount = $(this).data('value')

      self.setAmountOnForm(amount)
      self.openStripe(amount)
      return
    return

  otherAmountInput: ->
    self = this

    $("#donate_button").off('click').click (e) ->
      e.preventDefault()

      amount = self.amountInput.val()

      if amount is "" or amount < 1
        alert "Please check your donation amount."
      else
        self.openStripe(amount)
      return
    return

Cake.direct_donation.donate = (fundraiser_name, key, image)->
  new DirectDonation(fundraiser_name, key, image)
  return

Cake.direct_donation.init = ->
  return