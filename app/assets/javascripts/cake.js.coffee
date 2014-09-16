window.Cake ?= {}

Cake.init = ->
  Cake.clipboard()
  Cake.expander()
  Cake.videos()
  Cake.popover()
  Cake.datepicker()
  Cake.limit_cocoon()
  Cake.locations()
  Cake.sponsors_form()
  Cake.extra_donation_pledges()
  Cake.pledges.update_triggers()
  Cake.coupons.tos()
  Cake.clicks.get_plugins()

  Cake.validations.init()
  Cake.crop.init()
  return

$(document).ready(Cake.init)
$(document).on('page:load', Cake.init)

$(document).on "page:before-change", ->
  ZeroClipboard.destroy()
  return