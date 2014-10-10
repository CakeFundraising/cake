Cake.bootstrap_overrides ?= {}

Cake.bootstrap_overrides.hide_alert = ->
  window.setTimeout (->
    $(".alert.fade.in").fadeTo(500, 0).slideUp 500, ->
      $(this).remove()
      return
    return
  ), 2000
  return