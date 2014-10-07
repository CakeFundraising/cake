# turbolinks addthis
Cake.initAddthis = ->
  # Remove all global properties set by addthis, otherwise it won't reinitialize
  for i of window
    delete window[i]  if /^addthis/.test(i) or /^_at/.test(i)
  window.addthis_share = null
  
  # Finally, load addthis
  $.getScript "//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-53bd9dc0059c5a9e"
  return