Cake.fundraisers ?= {}

Cake.fundraisers.validation = ->
  $('.formtastic.fundraiser').validate(
    errorElement: "span"
    rules:
      'fundraiser[name]': 
        required: true
      'fundraiser[location_attributes][country_code]':
        required: true
      'fundraiser[location_attributes][zip_code]':
        required: true
        digits: true
      'fundraiser[location_attributes][city]':
        required: true
        onlyletters: true
      'fundraiser[location_attributes][address]':
        required: true
      'fundraiser[email]':
        required: true
        email: true
      'fundraiser[phone]':
        required: true
        digits: true
        minlength: 9
      'fundraiser[causes][]':
        required: true
      'fundraiser[website]':
        url: true
      'fundraiser[manager_name]':
        required: true
        onlyletters: true
      'fundraiser[manager_title]':
        required: true
        onlyletters: true
      'fundraiser[manager_email]':
        required: true
        email: true
      'fundraiser[manager_phone]':
        required: true
        digits: true
        minlength: 9
      'fundraiser[mission]':
        required: true
      'fundraiser[supporter_demographics]':
        required: true
  )
  return