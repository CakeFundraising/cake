Cake.clipboard = ->
  clipboard_button = $(".clipboard")
  clip = new ZeroClipboard($(".clipboard"))

  clip.on "ready", ->
    console.log "clipboard ready!"
    
    this.on "aftercopy", (event) ->
      #console.log "Text copied to clipboard!"
      console.log('Copied text to clipboard: ' + event.data['text/plain'])
      return
    return

  clip.on "error", (event) ->
    console.log( 'ZeroClipboard error of type "' + event.name + '": ' + event.message )
    return

  return