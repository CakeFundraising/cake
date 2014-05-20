class Fundraiser < ActiveRecord::Base
  include Cause

  belongs_to :manager, class_name: "User"
  has_one :location, as: :locatable, dependent: :destroy
  has_one :picture, as: :picturable, dependent: :destroy
  has_one :stripe_account, dependent: :destroy
  has_many :users
  has_many :campaigns, dependent: :destroy
  has_many :pledge_requests, dependent: :destroy
  has_many :pledges, through: :campaigns
  has_many :invoices, through: :pledges

  validates :name, :email, :phone, :causes, presence: true
  validates :email, email: true
  
  validates :mission, :manager_name, :manager_phone, :manager_title, :supporter_demographics, :manager_email, presence: true, unless: :new_record?
  validates :manager_email, email: true, unless: :new_record?

  accepts_nested_attributes_for :location, update_only: true, reject_if: :all_blank
  accepts_nested_attributes_for :picture, update_only: true, reject_if: :all_blank
  validates_associated :location
  validates_associated :picture

  delegate :avatar, :banner, :avatar_caption, :banner_caption, to: :picture

  after_initialize do
    if self.new_record?
      self.build_location
      self.build_picture if picture.blank?
    end
  end

  after_update do
    users.each do |user|
      UserNotification.fundraiser_profile_updated(self, user).deliver if user.fundraiser_email_setting.public_profile_change
    end
  end

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

  def sponsors
    pledges.accepted.active.eager_load(:sponsor).map(&:sponsor)
  end

  def create_stripe_account(auth)
    self.build_stripe_account(
      uid: auth.uid,
      stripe_publishable_key: auth.info.stripe_publishable_key,
      token: auth.credentials.token
    ).save
  end
end