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

  buttons.click ->
    spinner = $(this).siblings()
    spinner.removeClass('hidden')
    $(this).hide()
    return

  buttons.on "ajax:success", (e, data, status, xhr) ->
    spinner = $(this).siblings()
    spinner.hide()

    container = $(this).closest(".#{model}, ##{model}")
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

remoteTabs = ->
  $('[data-toggle="remoteTab"]').click (e) ->
    e.preventDefault()
    
    $this = $(this)
    loadurl = $this.attr('href')
    $targ = $($this.attr('data-target'))

    if $targ.is(':empty')
      $.get loadurl, (data) ->
        $targ.html data
        $targ.css('background', 'none')
        return

    $this.tab 'show'
    return
  return

Cake.utils.init = ->
  Cake.utils.load_all()
  remoteTabs()
  return