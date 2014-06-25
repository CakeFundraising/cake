Cake.share = ->
  shr = document.createElement("script")
  shr.setAttribute "data-cfasync", "false"
  shr.src = "//dsms0mj1bbhn4.cloudfront.net/assets/pub/shareaholic.js"
  shr.type = "text/javascript"
  shr.async = "true"
  shr.onload = shr.onreadystatechange = ->
    rs = @readyState
    return if rs and rs isnt "complete" and rs isnt "loaded"
    site_id = "ae715bac61754195bc4b8b1e924f0910"
    try
      Shareaholic.init site_id
    return
  s = document.getElementsByTagName("script")[0]
  s.parentNode.insertBefore shr, s
  return