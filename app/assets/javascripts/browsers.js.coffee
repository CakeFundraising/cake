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
  current_browser = localStorage.getItem('cake_current_browser_id')

  unless current_browser
    plugins = Cake.browsers.plugins()
    $.post '/browsers', {plugins: plugins.join(',')}, (data) ->
      localStorage.cake_current_browser_id = data
      console.log data
      return
  return