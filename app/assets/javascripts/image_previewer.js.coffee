image_previewer = ->
  get_image_class = (input) ->
    splitted_id = $(input).attr("class").split("_")
    picture_class = splitted_id[0]
    return picture_class

  readURL = (input) ->
    if input.files and input.files[0]
      reader = new FileReader()
      reader.onload = (e) ->
        img = new Image()
        img.src = reader.result

        if img.height > 2000 or img.width > 3000
          top = -60
        else
          if img.height >= img.width
            top = img.height*0.1*-1
          else
            top = img.width*0.025*-1

        img_tag = "<img alt=\"305x230\" class=\"img-responsive img-thumbnail\" style=\"margin-top: " + top + "px;\" src=\"" + e.target.result + "\">"

        $(input).siblings("."+ get_image_class(input)).html(img_tag)
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

$(document).ready(image_previewer)
$(document).on('page:load', image_previewer)
