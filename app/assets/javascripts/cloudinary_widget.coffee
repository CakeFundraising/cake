Cake.widget ?= {}

class Widget
  constructor: (options) ->
    @wrapper = $(options.wrapper)
    @preview = @wrapper.find(options.preview)
    @opener = @wrapper.find('.upload-button')

    @uriField = @wrapper.find('.uri_input')

    @x_coordinate = @wrapper.find('.coords .crop_x')
    @y_coordinate = @wrapper.find('.coords .crop_y')
    @w_coordinate = @wrapper.find('.coords .crop_w')
    @h_coordinate = @wrapper.find('.coords .crop_h')

    @options =
      cloud_name: 'cakefundraising'
      upload_preset: 'vgztqvaq'
      multiple: false
      cropping: 'server'
      cropping_aspect_ratio: options.ratio
      resource_type: 'image'
      client_allowed_formats: ["png", "jpg", "jpeg"]
      max_image_width: 5000
      max_image_height: 5000
      theme: 'minimal'
      show_powered_by: false

    @init()
    return

  open: ->
    self = this
    cloudinary.openUploadWidget @options, (error, result)->
      if error
        self.showError(error.message)
      else
        self.setInputFields(result[0])
        self.showPreview(result[0])
      return
    return

  init: ->
    self = this
    @opener.click (e)->
      e.preventDefault()
      self.open()
      return
    return

  showError: (message)->
    unless message is 'User closed widget'
      alert "There was an error when uploading your image: #{message}. We'll reload this page so you can try again."
      location.reload(true)
    return

  setInputFields: (upload)->
    coordinates = upload.coordinates.custom[0]
    imgIdentifier = "#{upload.resource_type}/#{upload.type}/#{upload.path}##{upload.signature}"

    @x_coordinate.val(coordinates[0])
    @y_coordinate.val(coordinates[1])
    @w_coordinate.val(coordinates[2])
    @h_coordinate.val(coordinates[3])

    @uriField.val(imgIdentifier)
    return

  showPreview: (upload)->
    coordinates = upload.coordinates.custom[0]

    previewImgPath = $.cloudinary.image(upload.public_id,
      crop: 'crop'
      x: coordinates[0]
      y: coordinates[1]
      width: coordinates[2]
      height: coordinates[3]
      class: 'img-responsive img-thumbnail'
    )

    @preview.html(previewImgPath)
    return


Cake.widget.new = (options)->
  new Widget(options)
  return