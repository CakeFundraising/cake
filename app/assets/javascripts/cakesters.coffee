Cake.cakesters ?= {}

validation = ->
  $('.formtastic.cakester').validate(
    errorElement: "span"
    rules:
      'cakester[name]': 
        required: true
      'cakester[location_attributes][country_code]':
        required: true
      'cakester[location_attributes][zip_code]':
        required: true
        digits: true
      'cakester[location_attributes][city]':
        required: true
        onlyletters: true
      'cakester[location_attributes][address]':
        required: true
      'cakester[email]':
        required: true
        email: true
      'cakester[phone]':
        required: true
        digits: true
        minlength: 10
      'cakester[causes][]':
        required: true
      'cakester[website]':
        required: true
        url: true
      'cakester[manager_name]':
        required: true
        onlyletters: true
      'cakester[manager_title]':
        required: true
        onlyletters: true
      'cakester[manager_email]':
        required: true
        email: true
      'cakester[manager_phone]':
        required: true
        digits: true
        minlength: 10
      'cakester[mission]':
        required: true
      'cakester[about]':
        required: true
  )
  return

campaignValidation = ->
  $('.formtastic.campaign').validate(
    errorElement: "span"
    rules:
      'campaign[uses_cakester]':
        required: true
      'campaign[any_cakester]':
        required: ->
          return $('input[name="campaign[uses_cakester]"]').val() == 1
      'campaign[cakester_id]':
        required: ->
          return $('input[name="campaign[any_cakester]"]').val() == 0
      'campaign[cakester_commission_percentage]':
        required: ->
          return $('input[name="campaign[uses_cakester]"]').val() == 1
  )
  return

Cake.cakesters.init = ->
  validation()
  campaignValidation()
  return