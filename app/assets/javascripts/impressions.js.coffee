Cake.impressions ?= {}

Cake.impressions.rendered = (impression_id)->
  if impression_id
    url = "/impressions/" + impression_id + "/rendered"

    $.ajax(
      url: url
      method: "PATCH"
    ).done (data)->
      console.log data
      return

    #Autoshow video
    Cake.videos.autoshow_modal()
  return