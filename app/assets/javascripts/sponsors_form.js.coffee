Cake.sponsors_form = ->
  
  $(":checkbox").each (o) ->
    textStr = $(this).parent("label").text()
    inputPH = $(this)
    $(this).text "test"
    $(this).parent().html inputPH
    $("<label class='new-label' for='" + $(this).attr("id") + "'>" + textStr + "</label>").insertAfter $(this)
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