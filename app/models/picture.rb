class Picture < ActiveRecord::Base
  belongs_to :picturable, polymorphic: true

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  AVATAR_SIZES = {
    ico: [25, 19],
    thumb: [50, 38],
    square: [120, 120],
    medium: [305, 230]
  }

  BANNER_SIZES = {
    large: [1400, 614],
    medium: [342, 150]
  }

  QRCODE_SIZES = {
    medium: [300, 300],
    large: [600, 600]
  }

  before_save do
    get_cloudinary_identifier(:avatar) if self.avatar.present? and self.avatar_changed?
    get_cloudinary_identifier(:banner) if self.banner.present? and self.banner_changed?
  end

  def get_cloudinary_identifier(image_type)
    preloaded = Cloudinary::PreloadedFile.new(self.send(image_type))         
    raise "Invalid upload signature" unless preloaded.valid?
    self.send("#{image_type}=", preloaded.identifier) 
  end
end
