Cake.initAddthis = ->
  # Remove all global properties set by addthis, otherwise it won't reinitialize
  if window.addthis
    window.addthis = null
    window._adr = null
    window._atc = null
    window._atd = null
    window._ate = null
    window._atr = null
    window._atw = null
    window.addthis_share = null

  # Finally, load addthis
  $.getScript "//s7.addthis.com/js/300/addthis_widget.js#async=1", ->
    window.addthis_config ?= {}
    window.addthis_config.pubid = 'ra-542a2ea07b4b6c5d'
    window.addthis.toolbox ".addthis_custom_follow, .addthis_sharing_toolbox, .addthis_jumbo_share"
    window.addthis.init()
    return
    
  return