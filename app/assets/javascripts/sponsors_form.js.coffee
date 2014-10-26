Cake.sponsors_form = ->
  $(".checkbox-pill").each (o) ->
    if !$(this).hasClass("done")
      textStr = $(this).parent("label").text()
      inputPH = $(this)
      $(this).text " "
      $(this).parent().html inputPH
      $("<label class='new-label' for='" + $(this).attr("id") + "'>" + textStr + "</label>").insertAfter $(this)
      $(this).last().addClass "done"
    return

  $(":checkbox:checked").each (o) ->
    chkID = $(this).attr("id")
    $(this).next().addClass "checked"
    return

  $("input[type='checkbox']").change ->
    if $(this).is(":checked")
      $(this).next().addClass "checked"
    else
      $(this).next().removeClass "checked"
    return
    
return    