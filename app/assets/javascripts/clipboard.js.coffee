ready = ->
  clip = new ZeroClipboard($("#clipboard"))

$(document).ready(ready)
$(document).on('page:load', ready)