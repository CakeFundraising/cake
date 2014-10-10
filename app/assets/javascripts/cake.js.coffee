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
  Cake.coupons.tos()
  Cake.clicks.get_plugins()
  Cake.validations.init()
  Cake.crop.init()
  #Cake.initAddthis()
  Cake.sponsors_form()
  Cake.campaigns.init()

  Cake.bootstrap_overrides.hide_alert()
  return

$(document).ready(Cake.init)
$(document).on('page:load', Cake.init)
#$(document).on('page:change', Cake.init)

$(document).on "page:before-change", ->
  ZeroClipboard.destroy()
  return