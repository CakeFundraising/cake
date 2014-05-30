Cake.pledges ?= {}

Cake.pledges.click = ->
  click_modal = $('#contribute_modal')
  contribute_button = click_modal.find("#contribute_link")

  contribute_button.click ->
    click_modal.find(".modal-body").html("<div class='lead'>Thanks for helping!</div>")
    $(this).hide()
    return
  return

Cake.pledges.update_triggers = ->
  $('#coupons').on 'cocoon:after-insert', ->
    Cake.extra_donation_pledges()
    Cake.datepicker()
    Cake.image_previewer()
  $('#sweepstakes').on 'cocoon:after-insert', ->
    Cake.image_previewer()
  return

Cake.pledges.coupons_switcher = ->
  checkbox = $('#pledge_show_coupons')
  checked = checkbox.prop('checked')
  coupons_container = $('#coupons')
  to_off_text = 'Click to skip this step ->'
  to_on_text = '<- Click to add coupons'

  checkbox.bootstrapSwitch({
    onText: 'Yes I want to add coupons',
    offText: 'No! Skip this step',
    offColor: 'primary',
    size: 'large',
    onSwitchChange: (event, state) ->
      coupons_container.slideToggle()

      if state
        $('label.bootstrap-switch-label').text(to_off_text)
      else
        $('label.bootstrap-switch-label').text(to_on_text)
      return
  });

  if checked
    $('label.bootstrap-switch-label').text(to_off_text)
    coupons_container.show()
  else
    $('label.bootstrap-switch-label').text(to_on_text)
    coupons_container.hide()

  return