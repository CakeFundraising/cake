Cake.campaigns ?= {}

#Campaign Show Functions
Cake.campaigns.countdown = (end_date) ->
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
  Cake.campaigns.countdown(end_date)
  return

Cake.campaigns.validation = ->
  $('.formtastic.campaign').validate(
    errorElement: "span"
    rules:
      'campaign[title]': 
        required: true
      'campaign[goal]':
        required: true
        currency: ["$", false]
      'campaign[launch_date]':
        required: true
      'campaign[end_date]':
        required: true
      'campaign[scopes][]':
        required: true
      'campaign[main_cause]':
        required: true
      'campaign[mission]':
        required: true
      # 'campaign[picture_attributes][banner]':
      #   required: true
      # 'campaign[picture_attributes][avatar]':
      #   required: true
      'campaign[headline]':
        required: true
      'campaign[story]':
        required: true
  )
  return