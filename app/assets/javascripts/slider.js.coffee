Cake.slider ?= {}
$fadeInt = 0

Cake.slider.cycleImages = ->
  $active = $("#cycler .active")
  $next = (if ($active.next().length > 0) then $active.next() else $("#cycler div:first"))
  $next.css "z-index", 2 #move the next image up the pile
  $active.fadeOut 1500, -> #fade out the top image
    $active.css("z-index", 1).show().removeClass "active" 
    $next.css("z-index", 3).addClass "active"
    return
  return

Cake.slider.init = ->
  unless $fadeInt
    $fadeInt = setInterval Cake.slider.cycleImages, 5000
  return

Cake.slider.destroy = ->
  clearInterval $fadeInt
  $fadeInt = null
  return





