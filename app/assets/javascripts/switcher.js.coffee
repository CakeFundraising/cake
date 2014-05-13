Cake.bootstrap_switcher = ->
  checkbox = $('#campaign_custom_pledge_levels')
  label = $('#campaign_custom_pledge_levels_input label.control-label')
  pledge_lavels_container = $('#sponsor_categories')
  checked = checkbox.prop('checked')

  checkbox.bootstrapSwitch({
    onText: 'Set custom pledge levels',
    offText: 'Display all Sponsors together in one level',
    size: 'large',
    onSwitchChange: (event, state) ->
      pledge_lavels_container.slideToggle()

      if state
        $('label.bootstrap-switch-label').text('Click to have just one level ->')
      else
        $('label.bootstrap-switch-label').text('<- Click to set custom levels')
      
      return
  });

  if checked
    $('label.bootstrap-switch-label').text('Click to have just one level ->')
    pledge_lavels_container.show()
  else
    $('label.bootstrap-switch-label').text('<- Click to set custom levels')
    pledge_lavels_container.hide()

  return