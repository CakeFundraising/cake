module Screenshotable
  include FacebookOpenGraph
  extend ActiveSupport::Concern

  def update_screenshot(url)
    screenshot_url = Cloudinary::Uploader.explicit(url, :type => "url2png")["url"].gsub('http:', 'https:')
    self.update_attribute(:screenshot_url, screenshot_url)
    FacebookOpenGraph.clear_cache(url)
  end
end