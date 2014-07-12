Cake.jquery_validator = ->
  $.validator.addMethod "minStrict", ((value, element, params) ->
    min = $(element).closest('.pledge_level').find('.min_value').text().replace('$','')
    parseInt(value) > parseInt(min)
  ), (params, element) ->
    min = $(element).closest('.pledge_level').find('.min_value').text().replace('$','')
    "Please enter a value greater than $" + min
  return