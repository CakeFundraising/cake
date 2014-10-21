Cake.clicks ?= {}

Cake.clicks.after_click = (website_url)->
  click_button = $('.click_link')
  modal = $('#click_counted.modal').first()
  thanks_button = '<a class="btn btn-success btn-xl" href="' + website_url + '" target="_blank">Thanks! Visit our Website Again</a>'
  buttons_wrapper = $('#buttons_section')

  click_button.click ->
    modal.modal('show')
    buttons_wrapper.html(thanks_button)
    return
  return