Cake.browsers ?= {}

Cake.browsers.plugins = ->
  plugins = []
  x = navigator.plugins.length
  i = 0

  while i < x
    plugins.push navigator.plugins[i].name
    i++
  return plugins.sort()

Cake.browsers.create = ->
  current_browser = sessionStorage.getItem('cake_current_browser')

  unless current_browser
    plugins = Cake.browsers.plugins()
    $.post '/browsers', {plugins: plugins.join(',')}, (data) ->
      sessionStorage.cake_current_browser = true
      console.log data
      return
  return