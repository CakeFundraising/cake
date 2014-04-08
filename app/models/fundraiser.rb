class Fundraiser < ActiveRecord::Base
  belongs_to :manager, class_name: "User"
  has_one :location, as: :locatable, dependent: :destroy
  has_one :picture, as: :picturable, dependent: :destroy
  has_many :users

  validates :name, :email, :phone, :cause, presence: true
  validates :email, email: true
  
  validates :name, :mission, :manager_title, :supporter_demographics, :manager_email, presence: true, unless: :new_record?
  validates :manager_email, email: true, unless: :new_record?

  accepts_nested_attributes_for :location, update_only: true, reject_if: :all_blank
  accepts_nested_attributes_for :picture, update_only: true, reject_if: :all_blank
  validates_associated :location
  validates_associated :picture

  delegate :avatar, :banner, :avatar_caption, :banner_caption, to: :picture

  after_initialize do
    if self.new_record?
      self.build_location
      self.build_picture
    end
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
