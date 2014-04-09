ready = ->
  $('.datepicker, .input-daterange').datepicker();

$(document).ready(ready)
$(document).on('page:load', ready)