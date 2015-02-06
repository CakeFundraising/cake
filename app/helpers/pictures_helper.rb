module PicturesHelper
  def avatar_tag_for(object, options={})
    options = {crop: :fill, width: 300, height: 200, quality: "jpegmini:0", sign_url: true, class: 'img-responsive'}.merge options
    cl_image_tag(object.avatar, options)
  end

  def screenshot_tag_for(object, options={})
    options = {quality: "jpegmini:0", sign_url: true, class: 'img-responsive'}.merge options
    cl_image_tag(object.screenshot_url, options)
  end
  
  def banner_tag_for(object, options={})
    options = {crop: :fill, width: 1400, height: 700, quality: "jpegmini:0", sign_url: true}.merge options
    cl_image_path(object.banner, options)
  end

  def qrcode_tag(object)
    options = {quality: "jpegmini:0", sign_url: true, class: "qr"}
    cl_image_tag(object.qrcode, options)
  end

  def picture_rollover(picture, url, &text)
    content_tag(:div, class:'overlay-effects', id:'effect-6') do
      content_tag(:div, class:'overlay-img') do
        picture + 
        content_tag(:div, class:'effect-overlay') do
          link_to url, target: :_blank, class:'expand' do
            text.call
          end
        end
      end
    end
  end
end