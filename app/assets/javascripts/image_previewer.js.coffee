ready = ->
  readURL = (input) ->
    if input.files and input.files[0]
      reader = new FileReader()
      reader.onload = (e) ->
        splitted_id = $(input).attr("id").split("_")
        picture_class = splitted_id[splitted_id.length-1]

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
        $("."+picture_class).html(img_tag)
        return

      reader.readAsDataURL input.files[0]
    return

  picturables = [
    "#campaign",
    "#fundraiser",
    "#sponsor",
    "#pledge"
  ]

  pictures_attributes = [
    "picture_attributes_banner",
    "picture_attributes_avatar"
  ]

  image_inputs = (picturable + "_" + pictures_attributes[0] + "," + picturable + "_" + pictures_attributes[1] for picturable in picturables)

  $(image_inputs.toString()).change ->
    readURL this
    return

$(document).ready(ready)
$(document).on('page:load', ready)