# turbolinks addthis
Cake.initAddthis = ->
  # Remove all global properties set by addthis, otherwise it won't reinitialize
  for i of window
    console.log window[i] if /^addthis/.test(i) or /^_at/.test(i)
    delete window[i]  if /^addthis/.test(i) or /^_at/.test(i)
  window.addthis_share = null
  
  # Finally, load addthis
  $.getScript "//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-542a2ea07b4b6c5d"

  #console.log $('#social')

  #$.getScript "//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-542a2ea07b4b6c5d", ->
  #  window.addthis.toolbox('#social')
  #  console.log $('#social')
  return