Cake.shareaholic ?= {}

Cake.shareaholic.load = ->
  site_id = "ae715bac61754195bc4b8b1e924f0910"
  try
    Shareaholic.init site_id
  return