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
  Cake.bootstrap_overrides.init()
  #Cake.coupons.tos()
  Cake.coupons.load_all()
  Cake.initAddthis()
  Cake.validations.init()
  Cake.crop.init()
  Cake.sponsors_form()
  Cake.campaigns.init()

  Cake.browsers.fingerprint()

  Cake.clicks.init()
  return

$(document).ready(Cake.init)
$(document).on('page:load', Cake.init)

$(document).on "page:before-change", ->
  ZeroClipboard.destroy()
  Cake.slider.destroy()
  return