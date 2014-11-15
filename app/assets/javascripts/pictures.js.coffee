Cake.pictures ?= {}

Cake.pictures.added_images = (stored_images)->
  form = $('.formtastic.pledge, .formtastic.campaign, .formtastic.fundraiser, .formtastic.sponsor')
  file_inputs = form.find('input[type="file"]')

  file_inputs.each ->
    current = $(this)
    type = current.data('cloudinary-field').split('[')[2].replace(']', '')

    eval('Cake.crop.' + type + 'Present = true;') if stored_images[type]
    return
  return

Cake.pictures.validation = ->
  forms = [
    '.formtastic.pledge', 
    '.formtastic.campaign', 
    '.formtastic.fundraiser', 
    '.formtastic.sponsor', 
    '.formtastic.fr_sponsor',
    '.formtastic.quick_pledge'
  ]

  form = $(forms.join(','))
  submit_button = form.find('input[type="submit"]')
  file_inputs = form.find('input[type="file"]')

  submit_button.click (e)->
    avatarPresent = Cake.pictures.avatarPresent
    bannerPresent = Cake.pictures.bannerPresent

    avatarUploaded = if (typeof Cake.crop.avatarPresent isnt "undefined" and Cake.crop.avatarPresent isnt null) then Cake.crop.avatarPresent else false
    bannerUploaded = if (typeof Cake.crop.bannerPresent isnt "undefined" and Cake.crop.bannerPresent isnt null) then Cake.crop.bannerPresent else false
    
    if (typeof avatarPresent isnt "undefined" and avatarPresent isnt null) and not avatarPresent and not avatarUploaded
      alert "Please check you've uploaded all required pictures."
      e.preventDefault()

    if (typeof bannerPresent isnt "undefined" and bannerPresent isnt null) and not bannerPresent and not bannerUploaded
      alert "Please check you've uploaded all required pictures."
      e.preventDefault()
    return 
  return