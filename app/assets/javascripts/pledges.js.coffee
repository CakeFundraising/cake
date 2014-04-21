Cake.pledges ?= {}

Cake.pledges.update_triggers = ->
  $('#coupons').on 'cocoon:after-insert', ->
    Cake.extra_donation_pledges()
    Cake.datepicker()
    Cake.image_previewer()
  $('#sweepstakes').on 'cocoon:after-insert', ->
    Cake.image_previewer()
  return