Cake.video ?= {}

Cake.video.init = (modal_id)->
  $(modal_id).on "hidden.bs.modal", (e) ->
    $(modal_id + " iframe").attr "src", $(modal_id + " iframe").attr("src")
    return
  return
