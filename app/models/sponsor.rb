class Sponsor < ActiveRecord::Base
  include Cause
  include Scope
  include CauseRequirement

  belongs_to :manager, class_name: "User"
  has_one :location, as: :locatable, dependent: :destroy
  has_one :picture, as: :picturable, dependent: :destroy
  has_many :users

  validates :name, :email, :phone, presence: true
  validates :email, email: true
  
  validates :mission, :manager_title, :supporter_demographics, :manager_email, presence: true, unless: :new_record?
  validates :manager_email, email: true, unless: :new_record?

  validates_inclusion_of :scopes, in: SCOPES, unless: :new_record?
  validates_inclusion_of :cause_requirements, in: CAUSE_REQUIREMENTS, unless: :new_record?
  validates_inclusion_of :causes, in: CAUSES, unless: :new_record?

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
end
