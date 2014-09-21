class PictureDecorator < ApplicationDecorator
  delegate_all

  def avatar(options={})
    if object.avatar.present?
      options = {crop: :crop, width: object.avatar_crop_w, height: object.avatar_crop_h, x: object.avatar_crop_x, y: object.avatar_crop_y, class: 'img-thumbnail img-responsive'}.merge options
      h.cl_image_tag(object.avatar, options)
    else
      h.image_tag 'http://www.placehold.it/305x230&text=no+image+available', class: 'img-thumbnail img-responsive'
    end
  end

  def banner(options={})
    if object.banner.present?
      options = {crop: :crop, width: object.banner_crop_w, height: object.banner_crop_h, x: object.banner_crop_x, y: object.banner_crop_y, class: 'img-thumbnail img-responsive'}.merge options
      h.cl_image_tag(object.banner, options)      
    else
      h.image_tag 'http://www.placehold.it/342x150&text=no+image+available', class: 'img-thumbnail img-responsive'
    end
  end

  def banner_path(options={})
    if object.banner.present?
      options = {crop: :crop, width: object.banner_crop_w, height: object.banner_crop_h, x: object.banner_crop_x, y: object.banner_crop_y}.merge options
      h.cl_image_path(object.banner, options)    
    else
      h.image_tag 'http://www.placehold.it/1400x614&text=no+image+available'
    end
  end

  def qrcode(options={})
    if object.qrcode.present?
      options = {crop: :crop, width: object.qrcode_crop_w, height: object.qrcode_crop_h, x: object.qrcode_crop_x, y: object.qrcode_crop_y, class: 'img-thumbnail img-responsive'}.merge options
      h.cl_image_tag(object.qrcode, options)
    else
      h.image_tag 'http://www.placehold.it/300x300&text=no+image+available', class: 'img-thumbnail img-responsive'
    end
  end
end