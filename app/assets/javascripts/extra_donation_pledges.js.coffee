Cake.extra_donation_pledges = ->
  checked = $(".extra_donation_pledge:checked")

  checked.each ->
    $(this).closest('.inputs').find('.extra_donation_pledge_collapse .collapse').collapse('show')

  $(".extra_donation_pledge").change ->
    $(this).closest('.inputs').find('.extra_donation_pledge_collapse .collapse').collapse('toggle')

  return