Cake.utils ?= {}

seeLess = (model, container)->
  button = "<div class='text-center'>
              <a class='btn btn-primary see_less_#{model}'>See Less</a>
            </div>"

  container.append(button)

  $button = container.find(".see_less_#{model}")

  $button.click ->
    container.find("#remote_#{model}").slideToggle('slow')
    $button.text(if $button.text() == 'See Less' then 'See More' else 'See Less')
    return
  return

seeMore = (model)->
  buttons = $(".load_all_#{model}")

  buttons.on "ajax:success", (e, data, status, xhr) ->
    container = $(this).closest(".#{model}, ##{model}")
    
    $(this).hide()
    container.append(data)

    seeLess(model, container)
    return
  return

Cake.utils.load_all = ->
  models = [
    'coupons',
    'news'
  ]

  for model in models
    seeMore(model)
  return

Cake.utils.init = ->
  Cake.utils.load_all()
  return