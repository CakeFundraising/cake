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

Cake.pledge_news.load_all = ->
  buttons = $('.load_all_news')

  buttons.on "ajax:success", (e, data, status, xhr) ->
    $(this).hide()
    $(this).closest('.news, #news').append(data)
    return
  return