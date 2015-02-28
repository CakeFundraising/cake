Cake.subscriptors ?= {}

Cake.subscriptors.open_url = (modal_id, url)->
  $("#{modal_id} .close, #{modal_id} #subscriptor_submit_action").click ->
    window.open url, '_blank'
    return
  return

Cake.subscriptors.validation = ->
  $('.formtastic.subscriptor').each ->
    $(this).validate(
      errorElement: "span"
      rules:
        'subscriptor[email]':
          required: true
          email: true
        'subscriptor[message]':
          required: true
    )
    return
  return