class Campaign < ActiveRecord::Base
  include Statusable
  has_statuses :private, :public, :launched

  belongs_to :fundraiser
  has_one :picture, as: :picturable, dependent: :destroy
  has_many :sponsor_categories, dependent: :destroy

  validates :title, :launch_date, :end_date, :cause, :headline, :status, :fundraiser, presence: true
  validates_associated :picture

  accepts_nested_attributes_for :picture, update_only: true, reject_if: :all_blank

  after_initialize do
    self.build_picture if self.new_record?
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

  DONATIONS_SETTINGS = [
    :campaign_page_only,
    :campaign_and_pledge_page,
    :no_donations
  ]
end
