class Sponsor < ActiveRecord::Base
  include Cause
  include Scope
  include CauseRequirement
  include Formats
  include Analytics
  include Picturable
  include Stripable

  belongs_to :manager, class_name: "User", dependent: :destroy
  has_one :location, as: :locatable, dependent: :destroy
  has_many :users
  has_many :pledge_requests, dependent: :destroy
  has_many :pledges, as: :sponsor, dependent: :destroy
  has_many :campaigns, through: :pledges
  has_many :invoices, through: :pledges

  has_many :payments, as: :payer, dependent: :destroy

  has_many :subscriptors, as: :object

  delegate :city, :state, :state_code, :country, :address, to: :location

  validates :name, :email, :phone, presence: true
  validates :email, email: true
  
  validates :mission, :manager_name, :manager_phone, :manager_title, :customer_demographics, :manager_email, presence: true, unless: :new_record?
  validates :manager_email, email: true, unless: :new_record?
  validates :website, format: {with: DOMAIN_NAME_REGEX, message: I18n.t('errors.url')}, unless: :new_record?

  accepts_nested_attributes_for :location, update_only: true, reject_if: :all_blank
  validates_associated :location

  after_initialize do
    if self.new_record?
      self.build_location
    end
  end

  after_create do
    UserNotification.new_sp(self.id).deliver
  end

  scope :rank, ->{ eager_load(:invoices).where(invoices: {status: "paid"}).order("invoices.due_cents DESC") }
  scope :local_rank, ->(zip_code){ eager_load(:invoices, :location).where(locations: {zip_code: zip_code}, invoices: {status: "paid"}).order("invoices.due_cents DESC") } 
  scope :latest, ->{ order(created_at: :desc) }

  scope :with_location, ->{ eager_load(:location) }

  #Solr
  searchable do
    text :name, boost: 2
    text :mission, :phone, :website, :email, :manager_name, :manager_email, :manager_phone
    text :city, :state_code

    text :zip_code do
      location.zip_code  
    end

    text :pledges_names do
      pledges.map {|p| p.name }
    end

    text :causes
    string :scopes, multiple: true
    string :causes, multiple: true

    string :zip_code do
      location.zip_code  
    end

    time :created_at
  end

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

  def self.popular
    self.with_picture.with_location.latest.first(12)
  end

  def accepted_pledges
    pledges.accepted.eager_load(:fundraiser)
  end

  def fundraisers_of(type) # type = :active || :past
    pledges.send(type).eager_load(:fundraiser).map(&:fundraiser).uniq
  end

  def fundraisers
    accepted_pledges.map(&:fundraiser).uniq
  end

  #### SP dashboard home
  def active_pledges_clicks_count
    pledges.active.sum(:clicks_count).to_i
  end

  #Notify profile update
  def notify_update
    users.each do |user|
      UserNotification.sponsor_profile_updated(self.id, user.id).deliver if user.sponsor_email_setting.public_profile_change
    end
  end
end
