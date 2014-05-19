window.Cake ?= {}

Cake.init = ->
  Cake.clipboard()
  Cake.datepicker()
  Cake.limit_cocoon()
  Cake.image_previewer()
  Cake.locations()
  Cake.extra_donation_pledges()
  Cake.pledges.update_triggers()
  Cake.bootstrap_switcher()
  Cake.stripe_ckeckout()
  return

$(document).ready(Cake.init)
$(document).on('page:load', Cake.init)