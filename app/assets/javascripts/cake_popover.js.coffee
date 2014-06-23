Cake.popover = ->
  $('.popover_button').popover(
    placement: 'top'
    html: true
  )
  $('.popover_button').on "shown.bs.popover", ->
    Cake.clipboard()
    return
  return