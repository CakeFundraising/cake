window.Cake ?= {}

String::capitalize = ->
  @charAt(0).toUpperCase() + @slice(1)

Cake.init = ->
  Cake.clipboard()
  Cake.expander()
  Cake.popover()
  Cake.datepicker()
  Cake.limit_cocoon()
  Cake.locations()
  Cake.placeholder_fix()
  Cake.extra_donation_pledges()
  Cake.pledges.update_triggers()
  Cake.initAddthis()
  Cake.sponsors_form()
  Cake.browsers.fingerprint()
  Cake.bootstrap_overrides.init()
  Cake.validations.init()
  Cake.crop.init()
  Cake.campaigns.init()
  Cake.clicks.init()
  Cake.utils.init()
  Cake.cakesters.init()
  Cake.chosen.init()
  Cake.search.init()
  Cake.slider.init()
  return

$(document).ready(Cake.init)
$(document).on('page:load', Cake.init)

$(document).on "page:before-change", ->
  ZeroClipboard.destroy()
  Cake.slider.destroy()
  return