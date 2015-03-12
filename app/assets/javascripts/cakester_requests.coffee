Cake.cakester_requests ?= {}

validation = ->
  $('.formtastic.cakester_request').validate(
    errorElement: "span"
    rules:
      'cakester_request[campaign_id]':
        required: true
      'cakester_request[rate]':
        required: true
      'cakester_request[message]':
        required: true
  )
  return

Cake.cakester_requests.init = ->
  validation()
  return