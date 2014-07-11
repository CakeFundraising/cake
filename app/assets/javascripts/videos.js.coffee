Cake.videos = ->
  modal = $("#video_modal")
  video_html = $("iframe#youtube_video").clone()

  modal.on "hidden.bs.modal", (e) ->
    $("iframe#youtube_video").remove()
    return

  modal.on "show.bs.modal", (e) ->
    if $("iframe#youtube_video").length == 0
      modal.find('.modal-body').append(video_html)
    return

  return