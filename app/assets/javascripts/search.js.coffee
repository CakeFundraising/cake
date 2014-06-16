Cake.search = Cake.search or {}

Cake.search = (form, resultsDiv) ->
  $form = $(form)
  $input = $form.find("#search")

  $input.on "keyup", ->
    clearTimeout $.data(this, "timer")
    $(this).data "timer", setTimeout(->
      $form.submit()
      return
    , 100)
    return

  $(document).on "ajax:success", form, (evt, data, status, xhr) ->
    $(resultsDiv).html data
    $(".pagination").show()
    $(".pagination").hide() if $("<div>" + data + "</div>").find(".score").size() <= 1
    $("nav.pagination").hide() if form is "#meat-search"
    return

  return