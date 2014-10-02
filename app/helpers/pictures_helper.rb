module PicturesHelper
  def avatar_tag_for(object, options={})
    options = {crop: :fill, width: 300, height: 200, class: 'img-responsive'}.merge options
    cl_image_tag(object.avatar, options)
  end

  def banner_tag_for(object, options={})
    options = {crop: :fill, width: 1400, height: 700}.merge options
    cl_image_path(object.banner, options)
  end

  def qrcode_tag(object)
    cl_image_tag(object.qrcode, class: "qr")
  end
end