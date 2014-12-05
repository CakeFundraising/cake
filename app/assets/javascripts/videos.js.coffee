Cake.videos ?= {}

Cake.videos.autoshow_modal = ->
  $('#video_modal').modal('show') if Cake.videos.autoshow
  return

Cake.videos.controls = (modal_id)->
  $(modal_id).on "hidden.bs.modal", (e) ->
    $(modal_id + " iframe").attr "src", $(modal_id + " iframe").attr("src")
    return
  return

Cake.videos.init = ->
  Cake.videos.controls(".video_modal")
  return