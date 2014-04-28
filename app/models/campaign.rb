class Campaign < ActiveRecord::Base
  include Cause
  include Scope

  attr_accessor :step 

  belongs_to :fundraiser
  has_one :picture, as: :picturable, dependent: :destroy
  has_one :video, as: :recordable, dependent: :destroy
  has_many :sponsor_categories, dependent: :destroy
  has_many :pledge_requests, dependent: :destroy
  has_many :pledges, dependent: :destroy
  has_many :sponsors, through: :pledges

  accepts_nested_attributes_for :picture, update_only: true, reject_if: :all_blank
  accepts_nested_attributes_for :video, update_only: true, reject_if: proc {|attrs| attrs[:url].blank? }
  accepts_nested_attributes_for :sponsor_categories, allow_destroy: true, reject_if: :all_blank

  validates :title, :launch_date, :end_date, :causes, :scopes, :headline, :story, :fundraiser, presence: true
  validates_associated :sponsor_categories, unless: :no_sponsor_categories
  validates_associated :picture

  delegate :avatar, :banner, :avatar_caption, :banner_caption, to: :picture

  scope :active, ->{where("? BETWEEN launch_date AND end_date", Date.today)}
  scope :past, ->{ where("end_date < ?", Date.today) }

  after_initialize do
    if self.new_record?
      self.build_picture if picture.blank?
    end
  end

  def active?
    (launch_date..end_date).cover?(Date.today)
  end

  def past?
    end_date < Date.today
  end
end
