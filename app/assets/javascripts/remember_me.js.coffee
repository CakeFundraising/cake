Cake.remember_me = ->
  console.log "Cake.remember_me"
  if !$(".checkbox").hasClass("done")
    #$(".checkbox").last().addClass "custom-checkbox"
    #$(".checkbox").last().addClass "onoffswitch"
    #$("<label class='onoffswitch-label' for='" + $(".checkbox .control-label").attr("for") + "'><span class='onoffswitch-inner'></span><span class='onoffswitch-switch'></span></label><span id='switch-text'>Remember Me</span>").appendTo ".checkbox .control-label"
    $(".checkbox").last().addClass "done"
return    