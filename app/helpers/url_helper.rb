module UrlHelper
  def url_with_protocol(url)
    (url=~/^https?:\/\//).nil? ? "http://#{url}" : url
  end
end