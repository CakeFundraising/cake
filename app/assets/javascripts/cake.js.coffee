window.Cake ?= {}

String::capitalize = ->
  @charAt(0).toUpperCase() + @slice(1)

Cake.init = ->
  Cake.clipboard()
  Cake.expander()
  Cake.videos()
  Cake.popover()
  Cake.datepicker()
  Cake.limit_cocoon()
  Cake.locations()
  Cake.extra_donation_pledges()
  Cake.pledges.update_triggers()
  Cake.bootstrap_overrides.hide_alert()
  #Cake.bootstrap_overrides.stacked_modals()
  #Cake.coupons.tos()
  Cake.initAddthis()
  Cake.validations.init()
  Cake.crop.init()
  Cake.sponsors_form()
  Cake.campaigns.init()

  Cake.browsers.fingerprint()

  Cake.campaigns.mini_pledges_click()
  return

$(document).ready(Cake.init)
$(document).on('page:load', Cake.init)

$(document).on "page:before-change", ->
  ZeroClipboard.destroy()
  Cake.slider.destroy()
  return