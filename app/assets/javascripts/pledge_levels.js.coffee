Cake.pledge_levels ?= {}
Cake.pledge_levels.validation ?= {}

# Validation
Cake.pledge_levels.validation.set_rules = ->
  jQuery.validator.addClassRules
    pledge_name:
      required: true
    max_value:
      required: true
      number: true
      minStrict: true
  return

Cake.pledge_levels.validation.validate = ->
  $('.formtastic.campaign').validate(
    errorElement: "span"
  ).form()
  return

##### Form
## Buttons
Cake.pledge_levels.show = ->
  checkbox = $('#campaign_custom_pledge_levels')
  pledge_levels_container = $('#sponsor_categories')
  custom_levels_button = $('.buttons #custom_levels')
  one_level_button = $('.buttons #one_level')

  checked = checkbox.prop('checked')

  if checked
    one_level_button.removeClass('btn-primary')
    custom_levels_button.addClass('btn-primary')
    pledge_levels_container.show()
  else
    custom_levels_button.removeClass('btn-primary')
    one_level_button.addClass('btn-primary')
    pledge_levels_container.hide()
  return

Cake.pledge_levels.switcher = ->
  checkbox = $('#campaign_custom_pledge_levels')
  custom_levels_button = $('.buttons #custom_levels')
  one_level_button = $('.buttons #one_level')

  Cake.pledge_levels.show()

  one_level_button.click (e)->
    e.preventDefault()
    checkbox.prop('checked', false)
    Cake.pledge_levels.show()
    return
    
  custom_levels_button.click (e)->
    e.preventDefault()
    checkbox.prop('checked', true)
    Cake.pledge_levels.show()
    return  

  return

## New pledge level
Cake.pledge_levels.set_min_value = (current, previous)->
  max_value = previous.find('.max_value')
  current_min_value_input = current.find('.input_min_value')
  current_min_value_span = current.find('.min_value')

  new_val = parseInt(max_value.val()) + 1
  current_min_value_input.val(new_val)
  current_min_value_span.html('$'+new_val)

  max_value.change ->
    val = parseInt($(this).val()) + 1
    current_min_value_input.val(val)
    current_min_value_span.html('$'+val)
    return
  return

Cake.pledge_levels.add_new = ->
  $("#sponsor_categories").on "cocoon:after-insert", (e, insertedItem) ->
    previous = insertedItem.siblings('.nested-fields').first()
    Cake.pledge_levels.set_min_value(insertedItem, previous)
    return
  return

# Init function
Cake.pledge_levels.init = ->
  Cake.pledge_levels.switcher()
  Cake.pledge_levels.validation.set_rules()
  Cake.pledge_levels.validation.validate()
  Cake.pledge_levels.add_new()