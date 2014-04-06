class Organization < ActiveRecord::Base
  belongs_to :user
  has_one :location, as: :locatable, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  validates_integrity_of  :avatar
  validates_processing_of :avatar

  validates :name, :email, :phone, presence: true, unless: :new_record?
  validates_associated :location

  accepts_nested_attributes_for :location, update_only: true, reject_if: :all_blank

  after_initialize do
    self.build_location if self.new_record?
  end
end
