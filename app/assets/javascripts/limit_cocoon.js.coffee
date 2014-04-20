ready = ->
  $('#coupons').cocoon_limiter()
  $('#sponsor_categories').cocoon_limiter()
  $('#sweepstakes').cocoon_limiter()

$(document).ready(ready)
$(document).on('page:load', ready)