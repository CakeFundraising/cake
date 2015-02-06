Cake.quick_pledges ?= {}

Cake.quick_pledges.validation = ->
  $('.formtastic.quick_pledge').validate(
    errorElement: "span"
    rules:
      'quick_pledge[name]': 
        required: true
      'quick_pledge[campaign_id]':
        required: true
      'quick_pledge[website_url]':
        required: true
        url: true
      'quick_pledge[amount_per_click]': 
        required: true
        currency: ["$", false]
        min: 1
      'quick_pledge[total_amount]':
        required: true
        currency: ["$", false]
        min: 50
      'quick_pledge[terms]':
        required: true
  )
  return