Cake.datepicker = ->
  $('.datepicker, .input-daterange').datepicker({
    format: 'mm/dd/yyyy'
    startDate: new Date() #today
    todayHighlight: true
  });