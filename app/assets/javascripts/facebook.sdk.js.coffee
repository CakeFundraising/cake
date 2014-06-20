Cake.facebook ?= {}

Cake.facebook.sdk = (app_id)->
  window.fbAsyncInit = ->
    FB.init
      appId: app_id
      xfbml: true
      version: "v2.0"
    return

  ((d, s, id) ->
    js = undefined
    fjs = d.getElementsByTagName(s)[0]
    return  if d.getElementById(id)
    js = d.createElement(s)
    js.id = id
    js.src = "//connect.facebook.net/en_US/sdk.js"
    fjs.parentNode.insertBefore js, fjs
    return
  ) document, "script", "facebook-jssdk"