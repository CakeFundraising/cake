Cake.pledges ?= {}

Cake.pledges.click = ->
  click_modal = $('#contribute_modal')
  contribute_button = click_modal.find("#contribute_link")

  contribute_button.click ->
    click_modal.find(".modal-body").html("<div class='lead'>Thanks for helping!</div>")
    $(this).hide()
    return
  return

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