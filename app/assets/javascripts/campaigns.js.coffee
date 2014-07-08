Cake.campaigns ?= {}

Cake.show_custom_pledge_levels = ->
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

Cake.custom_pledges_switcher = ->
  checkbox = $('#campaign_custom_pledge_levels')
  custom_levels_button = $('.buttons #custom_levels')
  one_level_button = $('.buttons #one_level')

  Cake.show_custom_pledge_levels()

  one_level_button.click (e)->
    e.preventDefault()
    checkbox.prop('checked', false);
    Cake.show_custom_pledge_levels()
    return
    
  custom_levels_button.click (e)->
    e.preventDefault()
    checkbox.prop('checked', true);
    Cake.show_custom_pledge_levels()
    return  

  return

Cake.campaigns.set_min_values = ->
  container = $('#sponsor_categories .nested-fields .pledge_level')
  max_value = container.find('.max_value')

  max_value.change ->
    self.closest('.pledge_level').find('.min_value').html(self.val())
    return
  return

Cake.campaigns.pledge_levels = ->
  Cake.custom_pledges_switcher()
  Cake.campaigns.set_min_values()



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
  return
