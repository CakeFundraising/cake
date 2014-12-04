Cake.clicks ?= {}

Cake.clicks.after_click = (website_url)->
  click_button = $('.click_link')
  modal = $('#click_counted.modal').first()
  thanks_msg = 'Thanks! Visit our Website Again'

  click_button.click ->
    modal.modal('show')
    click_button.text(thanks_msg)
    return
  return