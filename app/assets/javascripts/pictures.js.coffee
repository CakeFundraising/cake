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

    @alreadyPresent = ->
     return Cake.pictures[attrs.present]

    @uploaded = ->
      uploadPresent = (typeof Cake.crop[attrs.present] isnt "undefined" and Cake.crop[attrs.present] isnt null)
      return if uploadPresent then Cake.crop[attrs.present] else false

    @submitButton = @forms.find('input[type="submit"]')
    @errorMessageId = "#{@picType}-upload-error"

    @validate() if @shouldValidate
    return

  invalid: ->
    return (typeof @alreadyPresent() isnt "undefined" and @alreadyPresent() isnt null) and not @alreadyPresent() and not @uploaded()

  showMessage: ->
    message = "<div class='text-danger' id=\"#{@errorMessageId}\">Please upload a picture.</div>"
    pictureContainer = $(".#{@picType}")
    pictureContainer.before(message) unless $("##{@errorMessageId}").length > 0
    #alert "Please check you've uploaded all required #{self.picType} pictures."
    return

  removeMessage: ->
    $("##{@errorMessageId}").remove() if $("##{@errorMessageId}").length > 0
    return

  validate: ->
    self = this

    @submitButton.click (e)->
      if self.invalid()
        self.showMessage()
        e.preventDefault()
      else
        self.removeMessage()
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
    present: 'avatarPresent'
  )

  bannerValidator = new PictureValidation(
    type: 'banner'
    forms: forms
    present: 'bannerPresent'
  )

  return