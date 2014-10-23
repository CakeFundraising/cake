Cake.clipboard = ->
  clipboardButton = $(".clipboard")
  clip = new ZeroClipboard($(".clipboard"))

  clip.on "ready", ->
    this.on "aftercopy", (event) ->
      showMessage('Copied to clipboard!', 'success')
      return
    return

  clip.on "error", (event) ->
    showMessage('ZeroClipboard error of type "' + event.name + '": ' + event.message, 'danger')
    return

  showMessage = (message, messageType)->
    message = "<div class='alert alert-#{messageType} fade in'>#{message}</div>"
    clipboardButton.parent().append(message)
    Cake.bootstrap_overrides.hide_alert()
    return

  return