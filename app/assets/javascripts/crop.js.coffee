Cake.pictures ?= {}
Cake.crop ?= {}

########### Functions =================================================================
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

##### Image Class ####
class UploadedImage
  constructor: (reader, modal) ->
    img = new Image()
    img.src = reader.result

    @width = img.width
    @height = img.height
    @ratio = @calculate_ratio()
    @type = Cake.pictures.get_pic_type_from_modal(modal.attr('id'))

    if @type is 'banner'
      @min_size = 1400
    else
      @min_size = 305

    @modal = modal
    @modal_width = @calculate_modal_width()
    @modal_height = @calculate_modal_height()

  calculate_ratio: =>
    if 305 <= @width <= 900
      ratio = 1
    else if 901 <= @width <= 1400
      ratio = 2
    else if 1401 <= @width <= 2000
      ratio = 3
    else if 2001 <= @width <= 3000
      ratio = 4.5
    else if 3001 <= @width <= 4000
      ratio = 6
    else if 4001 <= @width <= 5000
      ratio = 8
    else if 5001 <= @width <= 6000
      ratio = 10
    else
      ratio = 12
    return ratio

  calculate_modal_width: =>
    return @width/@ratio

  calculate_modal_height: =>
    return @height/@ratio

##### Cropper Picture #####
class Cropper
  constructor: (modal, ratio, minSize_x, minSize_y) ->
    img_type = Cake.pictures.get_pic_type_from_modal(modal.attr('id'))
    img_ratio = Cake.pictures.current.ratio

    @modal = modal

    $(modal).find('#image-container').Jcrop
      aspectRatio: ratio
      setSelect: [0, 0, minSize_x, minSize_y]
      minSize: [minSize_x/ img_ratio, minSize_y/img_ratio]
      onSelect: (coords) =>
        $(modal).find('.crop_x').val(coords.x*img_ratio)
        $(modal).find('.crop_y').val(coords.y*img_ratio)
        $(modal).find('.crop_w').val(coords.w*img_ratio)
        $(modal).find('.crop_h').val(coords.h*img_ratio)
        return
      onChange: (coords) =>
        $(modal).find('.crop_x').val(coords.x*img_ratio)
        $(modal).find('.crop_y').val(coords.y*img_ratio)
        $(modal).find('.crop_w').val(coords.w*img_ratio)
        $(modal).find('.crop_h').val(coords.h*img_ratio)
      , ->
        Cake.crop.Jcrop = this
        return

  destroy: ->
    Cake.crop.Jcrop.destroy()
    @modal.find('.modal-body').append('<div id="image-container"></div>')
    return

##### CropForm #####
class CropForm
  constructor: (button) ->
    @form = $(button).closest('form.formtastic')
    @model = @form.attr('class').replace('formtastic ', '')
    @modal = $(button).closest('.modal')
    @input = @modal.siblings('.uploader.input').find('input[type="file"]')
    
    @x = @modal.find('.crop_x').val()
    @y = @modal.find('.crop_y').val()
    @w = @modal.find('.crop_w').val()
    @h = @modal.find('.crop_h').val()

    @img_type = Cake.pictures.get_pic_type_from_modal(@modal.attr('id'))
    @image = @input[0].files[0]

    @data = new FormData()

    ## Actions ##
    @loadData()
    return

  loadData: ->
    @data.append("crop_x", @x)
    @data.append("crop_y", @y)
    @data.append("crop_w", @w)
    @data.append("crop_h", @h)
    @data.append("img_type", @img_type)
    @data.append("model", @model)
    @data.append('image', @image)
    return

  get_server_model_url: ->
    model_id = @form.attr('action').split('/')[@form.attr('action').split('/').length - 1]
    url = '/' + @model + 's/' + model_id + '/pictures/crop'
    return url

  postToServer: ->
    #Ajax Call
    if @w > 0 and @h > 0
      modal = @modal
      img_type = @img_type
      input = @input

      $.ajax(
        url: @get_server_model_url()
        type: "POST"
        data: @data
        processData: false
        contentType: false
      ).done (data) ->
        Cake.crop.show_image(modal, img_type, data)
        Cake.pictures.clear_input(input)
        return
    else
      alert 'Please select a region.'
    return

########### Functions =================================================================

##### Load Picture #####
Cake.pictures.get_pic_type_from_input = (input) ->
  return $(input).attr("class").split("_")[0]

Cake.pictures.get_pic_type_from_modal = (modal) ->
  return modal.replace("#","").split("_")[0]

Cake.pictures.clear_input = (input) ->
  input.wrap("<form>").closest("form").get(0).reset()
  input.unwrap()
  return

Cake.pictures.load_pic = ->
  open_modal = (modal, img)->
    modal.find('.modal-body #image-container').css
      "background-image": "url('" + img + "')"
      width: Cake.pictures.current.modal_width + "px"
      height: Cake.pictures.current.modal_height + "px"

    modal.find('.modal-dialog').width(Cake.pictures.current.modal_width + 2)

    modal.modal('show')
    return

  readURL = (input) ->
    if input.files and input.files[0]
      reader = new FileReader()
      modal = $('#'+ Cake.pictures.get_pic_type_from_input(input) + '_crop_modal')

      reader.onload = (e) ->
        Cake.pictures.current = new UploadedImage(reader, modal)

        if Cake.pictures.current.width < Cake.pictures.current.min_size
          alert 'Please upload an image greater than ' + Cake.pictures.current.min_size + 'px width.'
          Cake.pictures.clear_input $(input)
        else
          img_tag = e.target.result
          open_modal(modal, img_tag)    
        return

      reader.readAsDataURL input.files[0]
    return

  inputs = [
    ".banner_input",
    ".avatar_input",
    ".qrcode_input"
  ]

  $(inputs.toString()).change ->
    readURL this
    return

  return

Cake.crop.select_region = ->
  avatar_crop_modal = $('#avatar_crop_modal')
  banner_crop_modal = $('#banner_crop_modal')

  avatar_crop_modal.on 'shown.bs.modal', ->
    ratio = Cake.pictures.avatarConstants.ratio
    minSize_x = Cake.pictures.avatarConstants.versions.medium.x
    minSize_y = Cake.pictures.avatarConstants.versions.medium.y

    Cake.crop.Cropper = new Cropper($(this), ratio, minSize_x, minSize_y)

    crop_button = $(this).find('#crop_button')

    crop_button.click ->
      $(this).text('Cropping Image ...')

      crop_form = new CropForm(this)
      crop_form.postToServer()
      return
    return

  banner_crop_modal.on 'shown.bs.modal', ->
    ratio = Cake.pictures.bannerConstants.ratio
    minSize_x = Cake.pictures.bannerConstants.versions.medium.x
    minSize_y = Cake.pictures.bannerConstants.versions.medium.y

    Cake.crop.Cropper = new Cropper($(this), ratio, minSize_x, minSize_y)

    crop_button = $(this).find('#crop_button')

    crop_button.click ->
      $(this).text('Cropping Image ...')

      crop_form = new CropForm(this)
      crop_form.postToServer()
      return
    return

  avatar_crop_modal.on 'hidden.bs.modal', ->
    Cake.crop.Cropper.destroy()
    return 

  banner_crop_modal.on 'hidden.bs.modal', ->
    Cake.crop.Cropper.destroy()
    return
  
  return

Cake.crop.show_image = (modal, img_type, data)->
  if data is 'There was a problem with your upload. Please try again.'
    alert data
    location.reload()
  else
    img_tag = "<img class=\"img-responsive img-thumbnail\" src=\"" + data + "\">"

    image_container = $('.uploader .'+ img_type)
    image_container.html img_tag

    Cake.crop.Cropper.destroy()
    modal.modal('hide')
  return

Cake.crop.init = ->
  Cake.pictures.load_pic()
  Cake.crop.select_region()
  return