Cake.browsers.fingerprint = ->
  if Cake.browsers.current
    $('body').trigger('current_browser_ready')
  else
    #Fingerprint JS
    fingerprint = new Fingerprint({screen_resolution: true, canvas: true, ie_activex: true}).get()
    #Evercookie
    ec = new evercookie()

    ec.get "cfbid", (value) ->
      if value
        storeFingerprinting(fingerprint, value)
      else
        ec_token = uuid.v1()
        ec.set('cfbid', ec_token)
        storeFingerprinting(fingerprint, ec_token)
      return

    storeFingerprinting = (fingerprint, token)->
      $.ajax(
        url: '/browser/fingerprint'
        method: 'PATCH'
        data: {fingerprint: fingerprint, ec_token: token}
      ).done (browser_id)->
        Cake.browsers.current = true if browser_id
        $('body').trigger('current_browser_ready')
      return

  return