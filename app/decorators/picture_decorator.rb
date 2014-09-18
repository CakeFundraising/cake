class PictureDecorator < ApplicationDecorator
  delegate_all

  def avatar(options={})
    options = {crop: :crop, width: object.avatar_crop_w, height: object.avatar_crop_h, x: object.avatar_crop_x, y: object.avatar_crop_y, class: 'img-thumbnail img-responsive'}.merge options
    h.cl_image_tag(object.avatar, options)
  end

  def banner(options={})
    options = {crop: :crop, width: object.banner_crop_w, height: object.banner_crop_h, x: object.banner_crop_x, y: object.banner_crop_y, class: 'img-thumbnail img-responsive'}.merge options
    h.cl_image_tag(object.banner, options)      
  end  

  def banner_path(options={})
    options = {crop: :crop, width: object.banner_crop_w, height: object.banner_crop_h, x: object.banner_crop_x, y: object.banner_crop_y}.merge options
    h.cl_image_path(object.banner, options)    
  end
end