Cake.users ?= {}

Cake.users.validation = ->
  $('.formtastic.user').validate(
    errorElement: "span"
    rules:
      'user[full_name]': 
        required: true
      'user[email]':
        required: true
        email: true
      'user[password]':
        minlength: 5
      'user[password_confirmation]':
        minlength: 5
        equalTo: "#user_password"
      'user[current_password]':
        minlength: 5
        required: true
  )
  return