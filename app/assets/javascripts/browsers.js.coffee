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
  unless Cake.browsers.current
    plugins = Cake.browsers.plugins()
    $.post '/browsers', {plugins: plugins.join(',')}, (data) ->
      Cake.browsers.current = true
      console.log data
      return
  return