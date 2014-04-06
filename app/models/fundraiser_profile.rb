class FundraiserProfile < ActiveRecord::Base
  belongs_to :user

  mount_uploader :banner, BannerUploader

  validates_integrity_of  :banner
  validates_processing_of :banner

  validates :cause, :name, :mission, :contact_title, 
  :supporter_demographic, :contact_email, presence: true, unless: :new_record?

  validates :contact_email, email: true

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
end
