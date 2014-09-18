Cake.pledge_levels ?= {}
Cake.pledge_levels.validation ?= {}
Cake.pledge_levels.set_levels ?= {}

# Validation
Cake.pledge_levels.validation.set_rules = ->
  jQuery.validator.addClassRules
    pledge_name:
      required: true
    max_value:
      required: true
      number: true
      minStrictPledgeLevels: true
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
    one_level_button.removeClass('btn-selected')
    custom_levels_button.addClass('btn-selected')
    pledge_levels_container.show()
  else
    custom_levels_button.removeClass('btn-selected')
    one_level_button.addClass('btn-selected')
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

# Init function
Cake.pledge_levels.init = ->
  Cake.pledge_levels.switcher()
  Cake.pledge_levels.validation.set_rules()
  Cake.pledge_levels.validation.validate()
  Cake.pledge_levels.levels_form.init()
  return