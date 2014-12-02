module Screenshotable
  include FacebookOpenGraph
  extend ActiveSupport::Concern

  def update_screenshot(url)
    screenshot_url = Cloudinary::Uploader.explicit(url, :type => "url2png")["url"]
    screenshot_version = Cloudinary::Uploader.explicit(url, :type => "url2png")["version"]
    self.update_attribute(:screenshot_url, screenshot_url)
    self.update_attribute(:screenshot_version, screenshot_version)
    FacebookOpenGraph.clear_cache(url)
  end
end