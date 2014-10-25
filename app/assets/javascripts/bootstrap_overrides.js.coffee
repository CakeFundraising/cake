Cake.bootstrap_overrides ?= {}

Cake.bootstrap_overrides.hide_alert = ->
  whitelisted_messages = [
    'A message with a confirmation link has been sent to your email address. Please open the link to activate your account.'
  ]

  alert = $(".alert.fade.in")
  message = alert.text().slice(1)

  unless message in whitelisted_messages
    window.setTimeout (->
      alert.fadeTo(500, 0).slideUp 500, ->
        $(this).remove()
        return
      return
    ), 3000
  return