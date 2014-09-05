Cake.pictures ?= {}
Cake.crop ?= {}

##### Pic Constants #####
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
    modal:
      x: 610
      y: 460

Cake.pictures.bannerConstants =
  ratio: 2.2801
  versions:
    large: 
      x: 1400
      y: 614
    medium:
      x: 342
      y: 150
    modal:
      x: 700
      y: 307

##### Load Picture #####
Cake.pictures.get_pic_type_from_input = (input) ->
  return $(input).attr("class").split("_")[0]

Cake.pictures.get_pic_type_from_modal = (modal) ->
  return modal.replace("#","").split("_")[0]

Cake.pictures.load_pic = ->
  open_modal = (input, img)->
    modal = $('#'+ Cake.pictures.get_pic_type_from_input(input) + '_crop_modal')

    modal.find('.modal-body #image-container').css
      "background-image": "url('" + img + "')"

    modal.modal('show')
    return

  readURL = (input) ->
    if input.files and input.files[0]
      reader = new FileReader()

      reader.onload = (e) ->
        img = new Image()
        img.src = reader.result

        Cake.crop.current_image_width = img.width
        Cake.crop.current_image_height = img.height

        img_tag = e.target.result

        open_modal(input, img_tag)    
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

##### Crop Picture #####
class Cropper
  constructor: (modal, ratio, minSize_x, minSize_y) ->
    img_type = Cake.pictures.get_pic_type_from_modal(modal.attr('id'))

    x_ratio = Cake.crop.current_image_width/Cake.pictures[img_type + 'Constants'].versions.modal.x
    y_ratio = Cake.crop.current_image_height/Cake.pictures[img_type + 'Constants'].versions.modal.y

    $(modal).find('#image-container').Jcrop
      aspectRatio: ratio
      setSelect: [0, 0, minSize_x, minSize_y]
      minSize: [minSize_x, minSize_y]
      onSelect: (coords) =>
        $(modal).find('.crop_x').val(coords.x*x_ratio)
        $(modal).find('.crop_y').val(coords.y*y_ratio)
        $(modal).find('.crop_w').val(coords.w*x_ratio)
        $(modal).find('.crop_h').val(coords.h*y_ratio)
        return
      onChange: (coords) =>
        $(modal).find('.crop_x').val(coords.x*x_ratio)
        $(modal).find('.crop_y').val(coords.y*y_ratio)
        $(modal).find('.crop_w').val(coords.w*x_ratio)
        $(modal).find('.crop_h').val(coords.h*y_ratio)
        return

Cake.crop.select_region = ->
  avatar_crop_modal = $('#avatar_crop_modal')
  banner_crop_modal = $('#banner_crop_modal')

  avatar_crop_modal.on 'shown.bs.modal', ->
    new Cropper($(this), Cake.pictures.avatarConstants.ratio, Cake.pictures.avatarConstants.versions.medium.x, Cake.pictures.avatarConstants.versions.medium.y)

    crop_button = $(this).find('#crop_button')
    crop_button.click ->
      Cake.crop.post_to_cropping(this)
      return
    return

  banner_crop_modal.on 'shown.bs.modal', ->
    new Cropper($(this), Cake.pictures.bannerConstants.ratio, Cake.pictures.bannerConstants.versions.medium.x, Cake.pictures.bannerConstants.versions.medium.y)

    crop_button = $(this).find('#crop_button')
    crop_button.click ->
      Cake.crop.post_to_cropping(this)
      return
    return
  
  return

Cake.crop.post_to_cropping = (button)->
  #$(button).closest('form.formtastic').submit()

  form = $(button).closest('form.formtastic')
  modal = $(button).closest('.modal')
  
  x = modal.find('.crop_x').val()
  y = modal.find('.crop_y').val()
  w = modal.find('.crop_w').val()
  h = modal.find('.crop_h').val()

  #Append data
  data = new FormData()

  data.append("crop_x", x)
  data.append("crop_y", y)
  data.append("crop_w", w)
  data.append("crop_h", h)

  img_type = Cake.pictures.get_pic_type_from_modal(modal.attr('id'))
  data.append("img_type", img_type)

  image = modal.siblings('.uploader.input').find('input[type="file"]')[0].files[0]
  data.append('image', image)

  #Get campaign ID
  campaign_id = form.attr('action').split('/')[form.attr('action').split('/').length - 1]

  #Ajax Call
  if w > 0 and h > 0
    url = "/campaigns/" + campaign_id + "/pictures/campaign_crop"

    $.ajax(
      url: url
      type: "POST"
      data: data
      processData: false
      contentType: false
    ).done (data) ->
      Cake.crop.show_cropped_image(modal, img_type, data)
      return

  else
    alert 'Please select a region.'
  return

Cake.crop.show_cropped_image = (modal, img_type, data)->
  image_container = $('.uploader .'+ img_type)

  if data is 'There was a problem with your upload. Please try again.'
    alert data
    location.reload()
  else
    img_tag = "<img class=\"img-responsive img-thumbnail\" src=\"" + data + "\">"
    image_container.html img_tag
    $(modal).modal('hide')

  return

Cake.crop.init = ->
  Cake.pictures.load_pic()
  Cake.crop.select_region()
  return