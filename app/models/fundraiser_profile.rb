class FundraiserProfile < ActiveRecord::Base
  belongs_to :user
  # has_one :location, as: :locatable

  # mount_uploader :avatar, AvatarUploader
  mount_uploader :banner, BannerUploader

  # validates_integrity_of  :avatar
  # validates_processing_of :avatar
  
  validates_integrity_of  :banner
  validates_processing_of :banner

  validates :cause, :name, :mission, :contact_title, 
  :supporter_demographic, :contact_email, presence: true, unless: :new_record?

  # accepts_nested_attributes_for :location, reject_if: :all_blank

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

  # DONATION_KINDS = [ ["No", false], ["Yes", true] ]
end
