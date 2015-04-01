#Campaign Show Functions
Cake.campaigns.countdown = (end_date) ->
  # There is a timezone issue that needs to be resolved
  # At least now the date is showing up on the iphone, although it is one day off.
  
  arr = end_date.split(/[- :]/)
  end_date = new Date(arr[0], arr[1] - 1, arr[2], arr[3], arr[4], arr[5])
  
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

Cake.campaigns.mini_pledges = ->
  if Modernizr.touch
    # show the close overlay button
    $(".close-overlay").removeClass "hidden"
    # handle the adding of hover class when clicked
    $(".overlay-img").click (e) ->
      $(this).addClass "hover"  unless $(this).hasClass("hover")
      return
    # handle the closing of the overlay
    $(".close-overlay").click (e) ->
      e.preventDefault()
      e.stopPropagation()
      $(this).closest(".overlay-img").removeClass "hover" if $(this).closest(".overlay-img").hasClass("hover")
      return
  else
    # handle the mouseenter functionality
    $(".overlay-img").mouseenter(->
      $(this).addClass "hover"
      return
    ).mouseleave -> # handle the mouseleave functionality
      $(this).removeClass "hover"
      return
  return

toggleNav = ->
  nav = $('nav.navbar.navbar-default')

  if nav.find('a.user-logged-in').length is 0
    expandLogo = $('.expand-nav')

    nav.hide()
    expandLogo.click ->
      $(this).hide()
      nav.fadeToggle(500)
      return
  return

Cake.campaigns.show = (end_date, impression_id, campaignId)->
  toggleNav()
  Cake.campaigns.countdown(end_date)
  Cake.impressions.rendered(impression_id)
  Cake.campaigns.mini_pledges()
  Cake.pusher.campaigns.updateRaised(campaignId) if campaignId
  return

Cake.campaigns.visibility = ->
  containers = $('.visibility_buttons')
  links = containers.find('a')

  links.on("ajax:success", (e, data, status, xhr) ->
    current = $(this)
    opposite = current.siblings("a")

    opposite.removeClass "hidden"
    current.addClass "hidden"
    return
  ).on "ajax:error", (e, xhr, status, error) ->
    alert "There were an error when updating campaign, please reload this page and try again."
    return
  return

Cake.campaigns.launch = ->
  buttons = $('.launch_button')
  launched_button = '<div class="btn btn-sm btn-success disabled">Launched</div>'

  buttons.on("ajax:success", (e, data, status, xhr) ->
    current = $(this)
    current.closest('td').html(launched_button)
    return
  ).on "ajax:error", (e, xhr, status, error) ->
    alert "There were an error when updating campaign, please reload this page and try again."
    return
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
      'campaign[headline]':
        required: true
      'campaign[story]':
        required: true
  )
  return

Cake.campaigns.init = ->
  Cake.campaigns.visibility()
  Cake.campaigns.launch()
  return