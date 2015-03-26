Cake.extra_clicks ?= {}

Cake.extra_clicks.after_click = ->
  click_button = $('.extra_click_link')
  modal = $('#extra_click_counted.modal').first()
  thanks_msg = 'Thanks! Visit our Website Again'

  click_button.click ->
    modal.modal('show')
    click_button.text(thanks_msg)
    click_button.removeClass('extra_click_link')
    return
  return

Cake.extra_clicks.volunteer_inner_click = ->
  click_button = $('#volunteer_inner_modal')

  modal = $('#extra_click_counted.modal').first()

  click_button.click ->
    modal.modal('hide')
    return

  return

Cake.extra_clicks.init = ->
  Cake.extra_clicks.after_click()
  Cake.extra_clicks.volunteer_inner_click()
  return