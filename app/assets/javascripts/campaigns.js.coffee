Cake.campaigns ?= {}

Cake.custom_pledges_switcher = ->
  checkbox = $('#campaign_custom_pledge_levels')
  label = $('#campaign_custom_pledge_levels_input label.control-label')
  pledge_levels_container = $('#sponsor_categories')
  checked = checkbox.prop('checked')
  to_off_text = 'Click to have just one level ->'
  to_on_text = '<- Click to set custom levels'

  checkbox.bootstrapSwitch({
    onText: 'Set custom pledge levels',
    offText: 'Display all Sponsors together in one level',
    size: 'large',
    onSwitchChange: (event, state) ->
      pledge_levels_container.slideToggle()

      if state
        $('label.bootstrap-switch-label').text(to_off_text)
      else
        $('label.bootstrap-switch-label').text(to_on_text)
      
      return
  });

  if checked
    $('label.bootstrap-switch-label').text(to_off_text)
    pledge_levels_container.show()
  else
    $('label.bootstrap-switch-label').text(to_on_text)
    pledge_levels_container.hide()

  return

Cake.campaign_countdown = (end_date) ->
  $("#campaign_countdown").countdown end_date, (event) ->
    countdown_section = $(this)
    # days
    countdown_section.find("span.campaign-timer.days").html event.strftime("%-D")
    # hours
    countdown_section.find("span.campaign-timer.hours").html event.strftime("%H")
    # minutes
    countdown_section.find("span.campaign-timer.mins").html event.strftime("%M")
    return

  return

Cake.campaigns.show = (end_date)->
  Cake.campaign_countdown(end_date)
  Cake.facebook.sdk('791515824214877')
  return
