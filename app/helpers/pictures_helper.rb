module PicturesHelper
  def avatar_tag_for(object, options={})
    options = {crop: :fill, width: 305, height: 230, class: 'img-responsive'}.merge options
    cl_image_tag(object.avatar, options)
  end

  def banner_tag_for(object, options={})
    options = {crop: :fill, width: 1400, height: 614}.merge options
    cl_image_path(object.banner, options)
  end

  def qrcode_tag(object)
    cl_image_tag(object.qrcode, class: "qr")
  end
end