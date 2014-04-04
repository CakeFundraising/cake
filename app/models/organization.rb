class Organization < ActiveRecord::Base
  belongs_to :user
  has_one :location, as: :locatable

  mount_uploader :avatar, AvatarUploader

  validates_integrity_of  :avatar
  validates_processing_of :avatar

  validates :name, :email, :phone, presence: true, unless: :new_record?

  accepts_nested_attributes_for :location, reject_if: :all_blank
end
