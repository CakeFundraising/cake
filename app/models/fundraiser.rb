class Fundraiser < ActiveRecord::Base
  include Cause

  belongs_to :manager, class_name: "User"
  has_one :location, as: :locatable, dependent: :destroy
  has_one :picture, as: :picturable, dependent: :destroy
  has_one :stripe_account, as: :account, dependent: :destroy
  has_many :users
  has_many :campaigns, dependent: :destroy
  has_many :pledge_requests, dependent: :destroy
  has_many :pledges, through: :campaigns
  has_many :invoices, through: :pledges

  has_many :received_payments, as: :recipient, class_name:'Payment', dependent: :destroy

  validates :name, :email, :phone, :causes, presence: true
  validates :email, email: true
  
  validates :mission, :manager_name, :manager_phone, :manager_title, :supporter_demographics, :manager_email, presence: true, unless: :new_record?
  validates :manager_email, email: true, unless: :new_record?

  accepts_nested_attributes_for :location, update_only: true, reject_if: :all_blank
  accepts_nested_attributes_for :picture, update_only: true, reject_if: :all_blank
  validates_associated :location
  validates_associated :picture

  delegate :avatar, :banner, :avatar_caption, :banner_caption, to: :picture

  monetize :min_pledge_cents
  monetize :min_click_donation_cents

  after_initialize do
    if self.new_record?
      self.build_location
      self.build_picture if picture.blank?
    end
  end

  MIN_PLEDGES = %w{20.00 50.00 100.00 200.00 500.00 750.00 1000.00 1500.00 2000.00 2500.00 3000.00 4000.00 5000.00 7500.00 10000.00 15000.00 20000.00 25000.00 50000.00 100000.00}

  MIN_CLICK_DONATIONS = %w{0.10 0.25 0.50 1.00 1.50 2.00 3.00 5.00 10.00}

  def sponsors
    pledges.accepted.active.eager_load(:sponsor).map(&:sponsor).uniq
  end

  #Stripe Account
  def stripe_account?
    stripe_account.present?
  end

  def create_stripe_account(auth)
    self.build_stripe_account(
      uid: auth.uid,
      stripe_publishable_key: auth.info.stripe_publishable_key,
      token: auth.credentials.token
    ).save
  end

  #Notify profile update
  def notify_update
    users.each do |user|
      UserNotification.fundraiser_profile_updated(self, user).deliver if user.fundraiser_email_setting.public_profile_change
    end
  end
end