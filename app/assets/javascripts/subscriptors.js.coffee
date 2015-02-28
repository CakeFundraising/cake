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

Cake.subscriptors.forwardVisitors = ->
  forwardButtons = $('.close, #subscriptor_submit_action')
  visitorUrl = $('.visitor-url').attr('href')

  forwardButtons.click ->
    window.open(visitorUrl, '_blank')
    return
