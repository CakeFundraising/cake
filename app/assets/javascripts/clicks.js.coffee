Cake.clicks ?= {}
Cake.browser ?= {}

Cake.browser.plugins = ->
  plugins = []
  x = navigator.plugins.length
  i = 0

  while i < x
    plugins.push navigator.plugins[i].name
    i++
  return plugins.sort()

Cake.clicks.get_plugins = ->
  if $(".click_link").length > 0
    plugins = Cake.browser.plugins()
    
    $(".click_link").attr "href", (index, value) ->
      href = value + "?click%5Bbrowser_plugins%5D=" + encodeURIComponent(plugins)
      href
  return

Cake.clicks.after_click = ->
  click_modal = $('#contribute_modal')
  contribute_form = click_modal.find(".formtastic.click")
  visit_sponsor_button = click_modal.find('#visit_sponsor_link')

  visit_sponsor_button.hide()

  contribute_form.submit (e)->
    e.preventDefault();
    this.submit();

    click_modal.find(".modal-body").html("<div class='lead'>Your click has already been counted, but please visit our sponsor again!</div>")
    $('#contribute_link').hide()
    visit_sponsor_button.show()
    return
  return