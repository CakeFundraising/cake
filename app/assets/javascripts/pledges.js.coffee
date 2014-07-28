Cake.pledges ?= {}

Cake.pledges.update_triggers = ->
  $('#coupons').on 'cocoon:after-insert', ->
    Cake.extra_donation_pledges()
    Cake.datepicker()
    Cake.image_previewer()
  $('#sweepstakes').on 'cocoon:after-insert', ->
    Cake.image_previewer()
  return

# Coupons switcher
Cake.show_coupons = ->
  checkbox = $('#pledge_show_coupons')
  coupons_container = $('#coupons')
  add_coupons = $('.buttons #add_coupons')
  no_coupons = $('.buttons #no_coupons')

  checked = checkbox.prop('checked')

  if checked
    no_coupons.removeClass('btn-primary')
    add_coupons.addClass('btn-primary')
    coupons_container.show()
  else
    add_coupons.removeClass('btn-primary')
    no_coupons.addClass('btn-primary')
    coupons_container.hide()
  return

Cake.pledges.coupons_switcher = ->
  checkbox = $('#pledge_show_coupons')
  add_coupons = $('.buttons #add_coupons')
  no_coupons = $('.buttons #no_coupons')

  Cake.show_coupons()

  no_coupons.click (e)->
    e.preventDefault()
    checkbox.prop('checked', false);
    Cake.show_coupons()
    return
    
  add_coupons.click (e)->
    e.preventDefault()
    checkbox.prop('checked', true);
    Cake.show_coupons()
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
        minStrict: 1
      'pledge[total_amount]':
        required: true
        currency: ["$", false]
        min: 50
      'pledge[website_url]':
        required: true
        url: true
      'pledge[terms]':
        required: true
      'pledge[mission]':
        required: true
      'pledge[picture_attributes][banner]':
        required: true
      'pledge[picture_attributes][avatar]':
        required: true
      'pledge[headline]':
        required: true
      'pledge[description]':
        required: true
  )
  return