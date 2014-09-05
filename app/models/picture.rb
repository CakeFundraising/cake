class Picture < ActiveRecord::Base
  belongs_to :picturable, polymorphic: true

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  mount_uploader :banner, BannerUploader
  validates_integrity_of  :banner
  validates_processing_of :banner
  
  mount_uploader :avatar, AvatarUploader
  validates_integrity_of  :avatar
  validates_processing_of :avatar
end
