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

### PICTURE VALIDATION ###
class PictureValidation
  constructor: (attrs) ->
    @picType = attrs.type
    @shouldValidate = true

    @forms = $(attrs.forms.join(','))

    @alreadyPresent = attrs.present
    @uploaded = if (typeof attrs.uploaded isnt "undefined" and attrs.uploaded isnt null) then attrs.uploaded else false

    @submitButton = @forms.find('input[type="submit"]')

    @validate() if @shouldValidate
    return

  invalid: ->
    return (typeof @alreadyPresent isnt "undefined" and @alreadyPresent isnt null) and not @alreadyPresent and not @uploaded

  validate: ->
    self = this

    @submitButton.click (e)->
      if self.invalid()
        alert "Please check you've uploaded all required #{self.picType} pictures."
        e.preventDefault()
      return
    return


Cake.pictures.validation = ->
  forms = [
    '.formtastic.pledge', 
    '.formtastic.campaign', 
    '.formtastic.fundraiser', 
    '.formtastic.sponsor', 
    '.formtastic.quick_pledge'
  ]

  avatarValidator = new PictureValidation(
    type: 'avatar'
    forms: forms
    present: Cake.pictures.avatarPresent
    uploaded: Cake.crop.avatarPresent
  )

  bannerValidator = new PictureValidation(
    type: 'banner'
    forms: forms
    present: Cake.pictures.bannerPresent
    uploaded: Cake.crop.bannerPresent
  )

  return