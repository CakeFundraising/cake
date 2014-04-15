class VideoDecorator < ApplicationDecorator
  delegate_all

  def thumbnail
    image_tag "http://img.youtube.com/vi/#{object.url}/1.jpg", :class => :thumbnail if object.url.present?
  end

  def iframe
    %Q{<iframe title="YouTube video player" width="100%" height="400px" src="http://www.youtube.com/embed/#{object.url}" frameborder="0" allowfullscreen></iframe>}.html_safe if object.url.present?
  end
end
