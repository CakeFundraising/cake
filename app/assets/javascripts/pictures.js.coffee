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
  form = $('.formtastic.pledge, .formtastic.campaign, .formtastic.fundraiser, .formtastic.sponsor')
  submit_button = form.find('input[type="submit"]')
  file_inputs = form.find('input[type="file"]')

  submit_button.click (e)->
    unless Cake.crop.avatarPresent and Cake.crop.bannerPresent
      alert "Avatar and Banner can't be blank"
      e.preventDefault()
    return 
  return