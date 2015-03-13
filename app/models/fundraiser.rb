class Fundraiser < ActiveRecord::Base
  include Cause
  include Formats
  include Analytics
  include Picturable
  include Clickable

  belongs_to :manager, class_name: "User", dependent: :destroy
  has_one :location, as: :locatable, dependent: :destroy
  has_one :stripe_account, as: :account, dependent: :destroy
  has_many :users
  has_many :campaigns, dependent: :destroy
  
  has_many :pledge_requests, dependent: :destroy

  has_many :pledges, ->{ normal }, through: :campaigns
  has_many :quick_pledges, ->{ quick }, through: :campaigns
  has_many :invoices, through: :pledges
  has_many :qp_invoices, through: :quick_pledges, source: :invoice

  has_many :fr_sponsors, dependent: :destroy

  has_many :received_payments, as: :recipient, class_name:'Payment', dependent: :destroy

  has_many :direct_donations, dependent: :destroy

  has_many :subscriptors, as: :object

  delegate :city, :state, :state_code, :country, :address, to: :location

  validates :name, :email, :phone, :causes, presence: true
  validates :email, email: true
  
  validates :mission, :manager_name, :manager_phone, :manager_title, :supporter_demographics, :manager_email, presence: true, unless: :new_record?
  validates :manager_email, email: true, unless: :new_record?
  validates :website, format: {with: DOMAIN_NAME_REGEX, message: I18n.t('errors.url')}, allow_blank: true

  accepts_nested_attributes_for :location, update_only: true, reject_if: :all_blank
  validates_associated :location

  monetize :min_pledge_cents
  monetize :min_click_donation_cents

  scope :rank, ->{ eager_load(:invoices).where(invoices: {status: "paid"}).order("invoices.due_cents DESC") }
  scope :local_rank, ->(zip_code){ eager_load(:invoices, :location).where(locations: {zip_code: zip_code}, invoices: {status: "paid"}).order("invoices.due_cents DESC") }
  scope :latest, ->{ order(created_at: :desc) }

  scope :with_location, ->{ eager_load(:location) }

  after_initialize do
    if self.new_record?
      self.build_location
    end
  end

  after_create do
    UserNotification.new_fr(self.id).deliver
  end

  MIN_PLEDGES = %w{20.00 50.00 100.00 200.00 500.00 750.00 1000.00 1500.00 2000.00 2500.00 3000.00 4000.00 5000.00 7500.00 10000.00 15000.00 20000.00 25000.00 50000.00 100000.00}

  MIN_CLICK_DONATIONS = %w{0.10 0.25 0.50 1.00 1.50 2.00 3.00 5.00 10.00}

  SUBSCRIBER_RANGES = [
    '0 to 500',
    '500 to 1,000', 
    '1,000 to 5,000', 
    '5,000 to 10,000', 
    '10,000 to 25,000',
    '25,000 to 50,000',
    '50,000 to 100,000', 
    '100,000 to 250,000', 
    '250,000 to 500,000',
    '500,000 to 1,000,000',
    '1,000,000 to 5,000,000',
    '5,000,000+'
  ]

  #Solr
  searchable do
    text :name, boost: 2
    text :mission, :phone, :website, :email, :manager_name, :manager_email, :manager_phone
    text :city, :state_code

    text :zip_code do
      location.zip_code  
    end

    text :campaigns_titles do
      campaigns.map {|p| p.title }
    end
    
    text :causes
    string :causes, multiple: true

    string :zip_code do
      location.zip_code  
    end

    time :created_at
  end

  def self.popular
    self.with_picture.with_location.latest.first(12)
  end

  def sponsors_of(type) # type = :active || :past
    pledges.send(type).includes(:sponsor).map(&:sponsor).uniq
  end

  def sponsors
    pledges.accepted_or_past.includes(:sponsor).map(&:sponsor).uniq
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
      UserNotification.fundraiser_profile_updated(self.id, user.id).deliver if user.fundraiser_email_setting.public_profile_change
    end
  end

  ###### Analytics methods #######
  def campaigns_count
    campaigns.count
  end

  def average_sponsors_per_campaign
    return 0 if campaigns_count.zero?
    (sponsors.count.to_f/campaigns_count.to_f).round(1)
  end

  def average_pledges_per_campaign
    return 0 if campaigns_count.zero?
    (pledges.count/campaigns_count).round
  end

  def active_campaigns_donation
    pledges.active.map(&:total_charge).sum
  end

  def average_clicks_per_campaign
    return 0 if campaigns_count.zero?
    (unique_clicks/campaigns_count).floor
  end

  def active?
    campaigns.active.any?
  end
end