Cake.shareaholic ?= {}

Cake.shareaholic.load = ->
  site_id = "ae715bac61754195bc4b8b1e924f0910"
  try
    Shareaholic.init site_id
  return

Cake.shareaholic.reload_page = ->
  alert('turbo')
  unless window.location.hash
    original_location = window.location
    window.location = original_location + "#."
    window.location.reload true
  return    

Cake.shareaholic.remove_hash = ->
  alert('normal')
  window.location.href.split('#')[0] if window.location.hash