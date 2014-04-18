class Campaign < ActiveRecord::Base
  include Statusable
  has_statuses :active, :past

  attr_accessor :step 

  belongs_to :fundraiser
  has_one :picture, as: :picturable, dependent: :destroy
  has_one :video, as: :recordable, dependent: :destroy
  has_many :sponsor_categories, dependent: :destroy
  has_many :pledges

  accepts_nested_attributes_for :picture, update_only: true, reject_if: :all_blank
  accepts_nested_attributes_for :video, update_only: true, reject_if: proc {|attrs| attrs[:url].blank? }
  accepts_nested_attributes_for :sponsor_categories, allow_destroy: true, reject_if: proc {|attrs| attrs[:name].blank? and attrs[:min_value] == '0.00' and attrs[:max_value] == '0.00' }

  validates :title, :launch_date, :end_date, :cause, :scope, :headline, :story, :status, :fundraiser, presence: true
  validates_associated :picture

  delegate :avatar, :banner, :avatar_caption, :banner_caption, to: :picture

  SCOPES = %w{Global National Regional Local}
  validates_inclusion_of :scope, in: SCOPES

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

  scope :active, ->{where("? BETWEEN launch_date AND end_date", Date.today)}
  scope :past, ->{ where("end_date < ?", Date.today) }

  after_initialize do
    if self.new_record?
      self.build_picture if picture.blank?
    end
  end

  def make_visible!
    update_attribute(:status, :public)
  end
end
