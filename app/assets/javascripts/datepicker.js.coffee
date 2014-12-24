Cake.datepicker = ->
  $('.datepicker, .input-daterange').datepicker({
    format: 'mm/dd/yyyy'
    startDate: new Date() #today
    todayHighlight: true
  });

Cake.placeholder_fix = ->
  input = $('.default-zero');
  input.val("") if input.val() == "0.00"
  return