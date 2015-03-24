Cake.home ?= {}

carousel = ->
  $('#home_carousel').owlCarousel
    items: 4
    loop: true
    margin: 10
    autoWidth:true
    autoplay: true
    autoplayTimeout: 1000
    autoplayHoverPause: true
  return

Cake.home.init = ->
  carousel()
  return
