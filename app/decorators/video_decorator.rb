class VideoDecorator < ApplicationDecorator
  delegate_all

  def thumbnail
    h.image_tag object.thumbnail, class: :thumbnail if object.thumbnail.present?
  end

  def iframe
    if object.url.present?
      if provider == 'youtube'
        %Q{<iframe id="youtube_video" title="YouTube video player" width="100%" height="400px" src="http://www.youtube.com/embed/#{object.url}" frameborder="0" allowfullscreen></iframe>}.html_safe
      elsif provider == 'vimeo'
        %Q{<iframe src="//player.vimeo.com/video/#{object.url}" width="100%" height="400px" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>}.html_safe
      end
    end
  end

  def input_value
    if object.url.present?
      if provider == 'youtube'
        "https://www.youtube.com/watch?v=#{object.url}"
      elsif provider == 'vimeo'
        "https://www.vimeo.com/#{object.url}"
      end
    end
  end
end
