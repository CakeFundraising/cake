ready = ->
  if $(".extra_donation_pledge").prop('checked')
    $(".extra_donation_pledge").closest('.inputs').find('.extra_donation_pledge_collapse .collapse').collapse('show')
   else 
    $(".extra_donation_pledge").closest('.inputs').find('.extra_donation_pledge_collapse .collapse').collapse('hide')

  $(".extra_donation_pledge").change ->
    $(this).closest('.inputs').find('.extra_donation_pledge_collapse .collapse').collapse('toggle')

    # Modal 
    # if this.checked
    #   $(this).closest('.inputs').find('.modal.fade').modal('show')

    return

$(document).ready(ready)
$(document).on('page:load', ready)