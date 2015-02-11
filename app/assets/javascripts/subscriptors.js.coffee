Cake.subscriptors ?= {}

Cake.subscriptors.validation = ->
  $('.formtastic.subscriptor').validate(
    errorElement: "span"
    rules:
      'subscriptor[email]':
        required: true
        email: true
  )
  return