Cake.carousel ?= {}

homeCarousel = ->
  $('#home_carousel').slick
    infinite: true
    speed: 500
    arrows: false
    slidesToShow: 8
    slidesToScroll: 1
    autoplay: true
    autoplaySpeed: 2000
  return

Cake.carousel.init = ->
  homeCarousel()
  return