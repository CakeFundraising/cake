class Picture < ActiveRecord::Base
  belongs_to :picturable, polymorphic: true

  AVATAR_SIZES = {
    ico: [25, 19],
    thumb: [50, 38],
    square: [120, 120],
    medium: [300, 200]
  }

  BANNER_SIZES = {
    large: [1400, 700],
    medium: [280, 140]
  }

  QRCODE_SIZES = {
    medium: [300, 300],
    large: [600, 600]
  }

  validates :avatar, presence: true, if: :persisted?

  before_save do
    unless Rails.env.test?
      get_cloudinary_identifier(:avatar) if self.avatar.present? and self.avatar_changed?
      get_cloudinary_identifier(:banner) if self.banner.present? and self.banner_changed?
      get_cloudinary_identifier(:qrcode) if self.qrcode.present? and self.qrcode_changed?
    end
  end

  def get_cloudinary_identifier(image_type)
    image_file = self.send(image_type)
    preloaded = Cloudinary::PreloadedFile.new(image_file)         
    raise "Invalid upload signature" unless preloaded.valid?
    self.send("#{image_type}=", preloaded.identifier) 
  end
end
