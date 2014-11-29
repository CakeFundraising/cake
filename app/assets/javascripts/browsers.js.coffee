Cake.browsers ?= {}

Cake.browsers.fingerprint = ->
  fingerprint = new Fingerprint({screen_resolution: true, canvas: true}).get()

  $.ajax(
    url: '/browser/fingerprint'
    method: 'PATCH'
    data: {fingerprint: fingerprint}
  ).done (data)->
    console.log data
    return

  return