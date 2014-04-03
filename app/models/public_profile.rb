class PublicProfile < ActiveRecord::Base
  belongs_to :user

  monetize :min_pledge_cents
  monetize :min_click_donation_cents

  mount_uploader :avatar, AvatarUploader
  mount_uploader :banner, BannerUploader

  validates_integrity_of  :avatar
  validates_processing_of :avatar
  
  validates_integrity_of  :banner
  validates_processing_of :banner

  validates :cause, :name, :head_line, :profile_message, :demographic_description, :email, presence: true, unless: :new_record?

  CAUSES = [
    "Global Initiatives",
    "National Initiatives",
    "Food and Hunger",
    "Medicine",
    "Education",
    "Animals and Wildlife",
    "Environment",
    "Water"
  ]

  MIN_PLEDGES = [
    10000,
    25000,
    50000,
    100000
  ]

  MIN_CLICK_DONATIONS = [
    3,
    5,
    7,
    10
  ]

  DONATION_KINDS = [ ["No", false], ["Yes", true] ]
end
