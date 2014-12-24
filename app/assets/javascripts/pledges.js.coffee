Cake.pledges ?= {}

Cake.pledges.update_triggers = ->
  $('#coupons').on 'cocoon:after-insert', ->
    Cake.extra_donation_pledges()
    Cake.datepicker()
    Cake.crop.init()
    return
  $('#sweepstakes').on 'cocoon:after-insert', ->
    Cake.image_previewer()
    return
  return

Cake.pledges.select_campaign_validator = (form_selector)->
  $(form_selector).validate(
    errorElement: "span"
    rules:
      campaign: 
        required: true
  ).form()
  return

Cake.pledges.validation = ->
  $('.formtastic.pledge').validate(
    errorElement: "span"
    rules:
      'pledge[amount_per_click]': 
        required: true
        currency: ["$", false]
        min: 1
      'pledge[total_amount]':
        required: true
        currency: ["$", false]
        min: 50
      'pledge[website_url]':
        required: true
        url: true
      'pledge[terms]':
        required: true
      'pledge[name]':
        required: true
      'pledge[mission]':
        required: true
      'pledge[headline]':
        required: true
      'pledge[description]':
        required: true
  )
  return
  