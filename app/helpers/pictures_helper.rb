module PicturesHelper
  def avatar_tag_for(object, options={})
    options = {crop: :fill, width: 300, height: 200, class: 'img-responsive'}.merge options
    cl_image_tag(object.avatar, options)
  end

  def screenshot_tag_for(object, options={})
    cl_image_tag(object, :type => "url2png", :crop => "fill", :width => 500, :gravity => "north", :sign_url => true, :class => 'img-responsive')
  end

  def screenshot_tag_for_remake(object, options={})
    #EMI
      #Generates a new screenshot
      #Need to store version as a reference. This is what enables us to access the most recent image.
      #new_screenshot["version"]

    #Recreate screenshot
    new_screenshot = Cloudinary::Uploader.explicit(object, :type => "url2png")
    cl_image_tag(object, :type => "url2png", :version => new_screenshot["version"], :crop => "fill", :width => 500, :gravity => "north", :sign_url => true, :class => 'img-responsive')
    
    #Force Facebook Update
    uri = URI.parse("https://graph.facebook.com")
    response = Net::HTTP.post_form(uri, {"scrape" => "true"})

  end

  def banner_tag_for(object, options={})
    options = {crop: :fill, width: 1400, height: 700}.merge options
    cl_image_path(object.banner, options)
  end

  def qrcode_tag(object)
    cl_image_tag(object.qrcode, class: "qr")
  end
end