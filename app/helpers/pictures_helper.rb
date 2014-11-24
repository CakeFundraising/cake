module PicturesHelper
  def avatar_tag_for(object, options={})
    options = {crop: :fill, width: 300, height: 200, class: 'img-responsive'}.merge options
    cl_image_tag(object.avatar, options)
  end

  def screenshot_tag_for(object, options={})
    #options = {type: 'url2png', :type => "url2png", :transformation => [{ :width => 400, :height => 400, :gravity => "north", :radius => 50, :border => "2px_solid_rgb:999"}], :sign_url => true, class: 'img-responsive'}.merge options
    

    Cloudinary::Uploader.explicit(object,
      :type => "url2png", :force => true,
      :transformation => [ 
        { :crop => "fill", :width => 500, :gravity => "north"}], 
      :sign_url => true, :class => 'img-responsive')


    cloudinary_url(object,
      :type => "url2png", 
      :crop => "fill", :width => 500, :gravity => :north, 
      :sign_url => true, :class => 'img-responsive')



    #cl_image_tag(object,
    #  :type => "url2png", :force => true,
    #  :transformation => [ 
    #    { :crop => "fill", :width => 500, :gravity => "north"}], 
    #  :sign_url => true, :class => 'img-responsive')



    #Cloudinary::Uploader.explicit
    #cl_image_tag(screenshot)

    #cloudinary_url(object,
    #  :type => "url2png", 
    #  :transformation => [ 
    #    { :crop => "fill", :width => 500, :gravity => "north"}], 
    #  :sign_url => true, :class => 'img-responsive')

    #cl_image_tag(object, options)
    #cl_image_tag(url_for(:controller => object.object.class.name.downcase.pluralize, :action => 'show', :id => object.id, :only_path => false), options)
  end

  def banner_tag_for(object, options={})
    options = {crop: :fill, width: 1400, height: 700}.merge options
    cl_image_path(object.banner, options)
  end

  def qrcode_tag(object)
    cl_image_tag(object.qrcode, class: "qr")
  end
end