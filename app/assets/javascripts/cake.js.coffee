window.Cake ?= {}

Cake.init = ->
  Cake.clipboard()
  Cake.jquery_validator()
  Cake.videos()
  Cake.popover()
  Cake.datepicker()
  Cake.limit_cocoon()
  Cake.image_previewer()
  Cake.locations()
  Cake.extra_donation_pledges()
  Cake.pledges.update_triggers()
  Cake.coupons.tos()
  Cake.clicks.get_plugins()
  return

$(document).ready(Cake.init)
$(document).on('page:load', Cake.init)

$(document).on "page:before-change", ->
  ZeroClipboard.destroy()
  return