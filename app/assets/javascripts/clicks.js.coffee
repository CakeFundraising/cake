Cake.clicks.after_click = ->
  click_button = $('.click_link')
  modal = $('#click_counted.modal').first()
  thanks_msg = 'Thanks! Visit our Website Again'

  click_button.click ->
    modal.modal('show')
    click_button.text(thanks_msg)
    click_button.removeClass('click_link')
    return
  return

updateRollover = (link)->
  overlay = link.closest('.effect-overlay')
  amount_per_click = link.closest('.mini-pledge').find('.levels span.amount_per_click').text() || $('#sponsors_banner #amount_per_click').text()
  fr = $('.fundraiser-name h4').text()

  unless overlay.hasClass('blue-bg')
    overlay.addClass('blue-bg').addClass('clicked')
    overlay.find('a.click-link').html("<div class='thanks'>Thank you!</div><div class='earning'>You earned #{amount_per_click} for #{fr}!</div>")
    
    window.onfocus = ->
      setTimeout (->
        overlay.removeClass('clicked')
        return
      ), 1000
      return
  return

Cake.clicks.mini_pledge = ->
  links = $('.click-link')

  links.click (e)->
    updateRollover($(this))
  return

Cake.clicks.hero_campaign = ->
  pic_link = $('.hero-pictures-section .click-link')
  click_button = $('.click_link')
  thanks_msg = 'Thanks! Visit our Website Again'
  modal = $('#click_counted.modal').first()

  pic_link.click ->
    click_button.text(thanks_msg)
    modal.modal('show')
    return

  click_button.click ->
    updateRollover(pic_link)
  return

Cake.clicks.init = ->
  Cake.clicks.hero_campaign()
  Cake.clicks.mini_pledge()
  Cake.clicks.after_click()
  return