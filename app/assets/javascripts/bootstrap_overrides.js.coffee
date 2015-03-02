Cake.bootstrap_overrides ?= {}

Cake.bootstrap_overrides.hide_alert = ->
  whitelisted_messages = [
    'A message with a confirmation link has been sent to your email address. Please open the link to activate your account.'
  ]

  alert = $(".alert.fade.in")
  message = alert.text().slice(1)

  unless message in whitelisted_messages
    window.setTimeout (->
      alert.fadeTo(500, 0).slideUp 500, ->
        $(this).remove()
        return
      return
    ), 3500
  return

Cake.bootstrap_overrides.stacked_modals = ->
  $(".modal").on "show.bs.modal", (event) ->
    idx = $(".modal:visible").length
    $(this).css "z-index", 1040 + (10 * idx)
    return

  $(".modal").on "shown.bs.modal", (event) ->
    idx = ($(".modal:visible").length) - 1 # raise backdrop after animation.
    $(".modal-backdrop").not(".stacked").css "z-index", 1039 + (10 * idx)
    $(".modal-backdrop").not(".stacked").addClass "stacked"
    return
  return

Cake.bootstrap_overrides.bootstrap_switch = ->
  $('.bootstrap_switch').bootstrapSwitch()

  $('.boolean_switch').bootstrapSwitch 
    onColor: 'success'
    offColor: 'danger'
    onText: 'Yes'
    offText: 'No'

  $('#hero_campaign_switch').bootstrapSwitch 
    onColor: 'success'
    offColor: 'default'
    onText: 'ONE Sponsor'
    offText: 'TWO OR MORE Sponsors'

  $('#any_cakester_switch').bootstrapSwitch 
    onText: 'To all Cakesters in Cake'
    offText: 'ONLY to the Cakester known as:'
  return

Cake.bootstrap_overrides.init = ->
  Cake.bootstrap_overrides.hide_alert()
  Cake.bootstrap_overrides.bootstrap_switch()
  return