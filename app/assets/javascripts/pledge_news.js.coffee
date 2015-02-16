Cake.pledge_news ?= {}

Cake.pledge_news.validation = ->
  $('.formtastic.pledge_news').validate(
    errorElement: "span"
    rules:
      'pledge_news[headline]':
        required: true
      'pledge_news[story]':
        required: true
      'pledge_news[url]':
        required: true
        url: true
  )
  return
  