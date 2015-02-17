Cake.subscriptors ?= {}

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