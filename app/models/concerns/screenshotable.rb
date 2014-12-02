module Screenshotable
  include FacebookOpenGraph
  extend ActiveSupport::Concern

  def update_screenshot(url)
    cloudinary_obj = Cloudinary::Uploader.explicit(url, :type => "url2png")
    screenshot_url = cloudinary_obj["url"].gsub('http:', 'https:')
    screenshot_version = "v#{cloudinary_obj['version']}"
    self.update_attribute(:screenshot_url, screenshot_url)
    self.update_attribute(:screenshot_version, screenshot_version)
    FacebookOpenGraph.clear_cache(url)
  end
end