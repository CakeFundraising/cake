Cake.impressions ?= {}

Cake.impressions.rendered = (impression_id)->
  if impression_id
    plugins = Cake.browser.plugins()
    url = "/impressions/" + impression_id + "/rendered"

    $.ajax(
      url: url
      method: "PATCH"
      data:
        browser_plugins: plugins
    ).done (data)->
      console.log data
      return
  return