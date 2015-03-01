Cake.chosen ?= {}

@chosenify = (select) ->
  select.chosen
    allow_single_deselect: true

general = ->
  chosenify $(".chosen-select")
  return

Cake.chosen.init = ->
  general()
  return