Cake.clicks ?= {}

Cake.clicks.after_click = ->
  click_button = $('.click_link')
  modal = $('#click_counted.modal')
  thanks_button = '<button class="btn btn-primary btn-xl disabled">Thanks for your contribution!</button>'
  buttons_wrapper = $('#buttons_section')

  click_button.click ->
    modal.modal('show')
    buttons_wrapper.html(thanks_button)
    return
  return