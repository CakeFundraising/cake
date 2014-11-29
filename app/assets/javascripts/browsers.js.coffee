Cake.browsers ?= {}

Cake.browsers.fingerprint = ->
  fingerprint = new Fingerprint({screen_resolution: true, canvas: true}).get()

  $.ajax(
    url: '/browser/fingerprint'
    method: 'PATCH'
    data: {fingerprint: fingerprint}
  ).done (token)->
    if token
      ec = new cake_evercookie();
      ec.set('cfbid', token)
      ec.get('cfbid');
    return

  return