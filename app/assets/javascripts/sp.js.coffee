Cake.sponsors ?= {}

Cake.sponsors.validation = ->
  $('.formtastic.sponsor').validate(
    errorElement: "span"
    rules:
      'sponsor[name]': 
        required: true
      'sponsor[location_attributes][country_code]':
        required: true
      'sponsor[location_attributes][zip_code]':
        required: true
        digits: true
      'sponsor[location_attributes][city]':
        required: true
        onlyletters: true
      'sponsor[location_attributes][address]':
        required: true
      'sponsor[email]':
        required: true
        email: true
      'sponsor[phone]':
        required: true
        digits: true
        minlength: 9
      'sponsor[website]':
        url: true
      'sponsor[manager_name]':
        required: true
        onlyletters: true
      'sponsor[manager_title]':
        required: true
        onlyletters: true
      'sponsor[manager_email]':
        required: true
        email: true
      'sponsor[manager_phone]':
        required: true
        digits: true
        minlength: 9
      'sponsor[mission]':
        required: true
      'sponsor[customer_demographics]':
        required: true
  )
  return