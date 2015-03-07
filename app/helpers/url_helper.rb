module UrlHelper
  def url_with_protocol(url)
    # /^http/i.match(url) ? url : "http://#{url}"
    (url=~/^https?:\/\//).nil? ? "http://#{url}" : url
  end
end