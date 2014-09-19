Cake.pictures ?= {}
Cake.crop ?= {}

########### Objects =================================================================
Cake.pictures.avatarConstants =
  ratio: 1.326087
  versions:
    medium:
      x: 305
      y: 230
    square: 
      x: 120
      y: 120
    thumb:
      x: 50
      y: 38
    ico:
      x: 25
      y: 19

Cake.pictures.bannerConstants =
  ratio: 2.2801
  versions:
    large: 
      x: 1400
      y: 614
    medium:
      x: 342
      y: 150

########### Classes =================================================================
##### Image Class ####
class UploadedImage
  constructor: (image) ->
    @image = image
    @width = image.width
    @height = image.height
    @ratio = @calculate_ratio()
    @modal_width = @calculate_modal_width()
    @modal_height = @calculate_modal_height()

    @validate_image()

  calculate_ratio: =>
    ratio = if @width > Cake.pictures.avatarConstants.versions.medium.x then Math.round(@width*0.0015) else 1
    return ratio

  calculate_modal_width: =>
    return Math.round @width/@ratio

  calculate_modal_height: =>
    return Math.round @height/@ratio

  validate_image: ->
    if @width <= Cake.pictures.avatarConstants.versions.medium.x
      @destroy()
      Cake.crop.modal.modal('hide')
      alert 'Please upload an image greater than 305x230px'
    return

  destroy_in_cloudinary: ->
    url = "https://api.cloudinary.com/v1_1/" + $.cloudinary.config().cloud_name + "/image/destroy"
    dataType = (if $.support.xhrFileUpload then "json" else "iframe json")

    $.ajax(
      url: url
      method: "POST"
      data:
        public_id: @image.public_id
        api_key: $.cloudinary.config().api_key
        timestamp: Date.now()
        signature: @image.signature #error here
      headers:
        "X-Requested-With": "XMLHttpRequest"
    ).done ->
      console.log 'Image deleted.'
      return
    return

  destroy: ->
    #@destroy_in_cloudinary()
    $('input[type="hidden"][name="' + Cake.crop.input.data('cloudinary-field') + '"]').remove() #remove hidden tag
    $('#image-container').empty()
    return

##### Cropper Picture #####
class Cropper
  constructor: (ratio, minSize_x, minSize_y) ->
    @img_ratio = Cake.pictures.current.ratio

    @modal = Cake.crop.modal
    @input = Cake.crop.input

    @modal.find('#image-container img').Jcrop
      aspectRatio: ratio
      minSize: [minSize_x/ @img_ratio, minSize_y/@img_ratio]
      setSelect: [0, 0, minSize_x, minSize_y]
      onSelect: (coords) =>
        @update(coords)
        return
      onChange: (coords) =>
        @update(coords)
        return
      , ->
        Cake.crop.Jcrop = this
        return

  update: (coords) ->
    Cake.crop.coords_container.find('.crop_x').val( Math.round(coords.x*@img_ratio) )
    Cake.crop.coords_container.find('.crop_y').val( Math.round(coords.y*@img_ratio) )
    Cake.crop.coords_container.find('.crop_w').val( Math.round(coords.w*@img_ratio) )
    Cake.crop.coords_container.find('.crop_h').val( Math.round(coords.h*@img_ratio) )
    return

  destroy: ->
    Cake.crop.Jcrop.destroy() if Cake.crop.Jcrop
    $('#no_upload').show()
    $('#image-container').empty()
    return

class CroppedImage
  constructor: (image) ->
    @image = image
    return

  show: ->
    image_tag = $.cloudinary.image(@image.public_id,
      crop: 'crop'
      x: Cake.crop.coords_container.find('.crop_x').val()
      y: Cake.crop.coords_container.find('.crop_y').val()
      width: Cake.crop.coords_container.find('.crop_w').val()
      height: Cake.crop.coords_container.find('.crop_h').val()
      class: 'img-responsive img-thumbnail'
    )

    Cake.crop.image_previewer.html image_tag

    Cake.crop.modal.modal('hide')

    alert "Your new " + Cake.crop.type + " picture is in preview mode, please save this form to save it permanently." 
    return

########### Functions =================================================================

Cake.crop.main = (image)->
  Cake.pictures.current = new UploadedImage(image)

  $('#no_upload').hide()

  Cake.crop.modal.find('.modal-body #image-container').html(
    $.cloudinary.image(image.public_id,
      format: image.format
      crop: 'fit'
      width: Cake.pictures.current.modal_width
      height: Cake.pictures.current.modal_height
    )
  )
  Cake.crop.modal.find('.modal-dialog').width(Cake.pictures.current.modal_width + 2)

  typeConstants = eval "Cake.pictures." + Cake.crop.type + "Constants"

  Cake.crop.Cropper = new Cropper(
    typeConstants.ratio, 
    typeConstants.versions.medium.x,
    typeConstants.versions.medium.y
  )

  crop_button = Cake.crop.modal.find('#crop_button')
  crop_button.click ->
    cropped_image = new CroppedImage(image)
    cropped_image.show()
    return

  return

Cake.crop.init = ->
  Cake.crop.modal = $('#crop_modal')
  Cake.crop.input_selector = $('.cloudinary-fileupload')

  Cake.crop.modal.on 'hidden.bs.modal', ->
    Cake.crop.Cropper.destroy()
    return 

  modal_cancel = Cake.crop.modal.find('button[data-dismiss="modal"]')
  modal_cancel.click ->
    Cake.pictures.current.destroy()
    return

  Cake.crop.input_selector.on 'cloudinaryprogressall', (e, data)->
    progress = parseInt(data.loaded/data.total * 100, 10);
    $('#overlay_loading').html '<span class="upload-progress">' + progress + '&#37;</span>'
    return

  Cake.crop.input_selector.on 'cloudinarystart', ->
    #if $(this).attr('crop') is "true"
    Cake.crop.input = $(this)
    Cake.crop.type = $(this).data('cloudinary-field').split("[")[2].replace("]", '')
    Cake.crop.image_previewer = $('.uploader .'+ Cake.crop.type)
    Cake.crop.coords_container = $('#' + Cake.crop.type + '_coords')

    Cake.crop.modal.modal('show')

    $(this).on 'cloudinarydone', (e, data)->
      Cake.crop.main(data.result)
      return
    return

  return
