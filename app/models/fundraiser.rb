class Fundraiser < ActiveRecord::Base
  has_one :location, as: :locatable, dependent: :destroy
  belongs_to :manager, class_name: "User"
  has_many :users

  mount_uploader :banner, BannerUploader
  mount_uploader :avatar, AvatarUploader
  validates_integrity_of  :banner
  validates_processing_of :banner
  validates_integrity_of  :avatar
  validates_processing_of :avatar

  validates :organization_name, :email, :phone, :cause, presence: true
  validates :email, email: true
  
  validates :name, :mission, :manager_title, :supporter_demographics, :manager_email, presence: true, unless: :new_record?
  validates :manager_email, email: true, unless: :new_record?

  accepts_nested_attributes_for :location, update_only: true, reject_if: :all_blank
  validates_associated :location

  after_initialize do
    self.build_location if self.new_record?
  end

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
