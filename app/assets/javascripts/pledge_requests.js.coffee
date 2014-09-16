Cake.pledge_requests ?= {}

Cake.pledge_requests.validation = ->
  $('.formtastic.pledge_request, .formtastic.reject_message').validate(
    errorElement: "span"
    rules:
      'pledge_request[message]':
        required: true
      'reject_message[message]':
        required: true
  )
  return