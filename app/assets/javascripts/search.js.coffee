Cake.search = Cake.search or {}

Cake.search = (form, resultsDiv) ->
  $form = $(form)
  $input = $form.find("#search")

  timer = null
  delay = 500
  $input.on "keyup", ->
    window.clearTimeout timer if timer
    timer = window.setTimeout(->
      timer = null
      $form.submit()
      return
    , delay)
    return

  $(document).on "ajax:success", form, (evt, data, status, xhr) ->
    $(resultsDiv).html data
    $("#search").focus()
    return

  return