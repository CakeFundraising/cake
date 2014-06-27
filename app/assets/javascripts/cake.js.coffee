window.Cake ?= {}

Cake.init = ->
  Cake.clipboard()
  Cake.popover()
  Cake.datepicker()
  Cake.limit_cocoon()
  Cake.image_previewer()
  Cake.locations()
  Cake.extra_donation_pledges()
  Cake.pledges.click()
  Cake.pledges.update_triggers()
  Cake.shareaholic.load()

$(document).ready(Cake.init)
$(document).on('page:load', Cake.init)

$(document).on "page:before-change", ->
  ZeroClipboard.destroy()
  return