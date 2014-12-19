Cake.disqus ?= {}

Cake.disqus.init = (disqus_shortname, disqus_identifier, disqus_title, disqus_url, disqus_category_id) ->
  if window.dsq
    DISQUS.reset
      reload: true
      config: ->
        @page.identifier = disqus_identifier
        @page.url = disqus_url
        @page.title = disqus_title
        return
  else
    window.dsq = document.createElement("script")
    window.dsq.type = "text/javascript"
    window.dsq.async = true
    window.dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js"
    (document.getElementsByTagName("head")[0] or document.getElementsByTagName("body")[0]).appendChild dsq
  return