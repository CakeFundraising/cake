class Campaign < ActiveRecord::Base
  include Statusable
  has_statuses :private, :public, :launched

  attr_accessor :step 

  belongs_to :fundraiser
  has_one :picture, as: :picturable, dependent: :destroy
  has_many :sponsor_categories, dependent: :destroy

  validates :title, :launch_date, :end_date, :cause, :headline, :status, :fundraiser, presence: true
  validates_associated :picture

  accepts_nested_attributes_for :picture, update_only: true, reject_if: :all_blank
  accepts_nested_attributes_for :sponsor_categories, allow_destroy: true, reject_if: proc {|attributes| attributes['name'].blank? }

  delegate :avatar, :banner, :avatar_caption, :banner_caption, to: :picture

  after_initialize do
    build_picture if picture.blank?
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
  validates_inclusion_of :cause, in: CAUSES

  DONATIONS_SETTINGS = [
    :campaign_page_only,
    :campaign_and_pledge_page,
    :no_donations
  ]

  def make_visible!
    update_attribute(:status, :public)
  end
end
