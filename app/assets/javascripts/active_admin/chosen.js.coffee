@chosenify = (entry) ->
  entry.chosen
    allow_single_deselect: true

$ -> 
  chosenify $(".chosen-select")

  $("form.formtastic .inputs .has_many").click ->
    $(".chosen-select").chosen
      allow_single_deselect: true