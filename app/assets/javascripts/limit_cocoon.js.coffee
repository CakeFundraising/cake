ready = ->
  $('#coupons').cocoon_limiter()

$(document).ready(ready)
$(document).on('page:load', ready)