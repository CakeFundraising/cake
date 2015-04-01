Cake.mailers.contact_validation = ->
  $('.formtastic.contact_mailer').validate(
    errorElement: "span"
    rules:
      'contact_mailer[name]':
        required: true
        onlyletters: true
      'contact_mailer[email]':
        required: true
        email: true
      'contact_mailer[phone]':
        required: true
        digits: true
      'contact_mailer[message]':
        required: true
      'contact_mailer[topic]':
        required: true
  )
  return