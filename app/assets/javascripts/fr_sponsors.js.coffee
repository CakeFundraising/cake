Cake.fr_sponsors.validation = ->
  $('.formtastic.fr_sponsor').validate(
    errorElement: "span"
    rules:
      'fr_sponsor[name]': 
        required: true
      'fr_sponsor[location_attributes][country_code]':
        required: true
      'fr_sponsor[location_attributes][zip_code]':
        required: true
        digits: true
      'fr_sponsor[location_attributes][city]':
        required: true
        onlyletters: true
      'fr_sponsor[location_attributes][address]':
        required: true
      'fr_sponsor[email]':
        required: true
        email: true
      'fr_sponsor[website_url]':
        required: true
        url: true
      'fr_sponsor[picture_permission]':
        required: true
  )
  return