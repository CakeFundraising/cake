Cake.pledges ?= {}

Cake.pledges.update_triggers = ->
  $('#coupons').on 'cocoon:after-insert', ->
    Cake.extra_donation_pledges()
    Cake.datepicker()
    Cake.image_previewer()
  $('#sweepstakes').on 'cocoon:after-insert', ->
    Cake.image_previewer()
  return

Cake.pledges.click = ->
  click_modal = $('#contribute_modal')
  contribute_button = click_modal.find("#contribute_link")

  contribute_button.click ->
    click_modal.find(".modal-body").html("<div class='lead'>Thanks for helping!</div>")
    $(this).hide()
    return
  return