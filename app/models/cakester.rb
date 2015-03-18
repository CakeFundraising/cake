class Cakester < ActiveRecord::Base
  include Cause
  include Scope
  include CauseRequirement
  include Formats
  include Picturable
  include Stripable

  belongs_to :manager, class_name: "User", dependent: :destroy
  has_one :location, as: :locatable, dependent: :destroy

  has_many :users, as: :role, dependent: :destroy

  has_many :subscriptors, as: :object

  #Cakester Requests
  has_many :cakester_requests, dependent: :destroy
  has_many :campaign_cakesters, dependent: :destroy
  has_many :pledge_requests, as: :requester, dependent: :destroy

  has_many :ap_cakester_requests, ->{ pending_or_accepted }, class_name: 'CakesterRequest', dependent: :destroy
  has_many :campaigns, through: :campaign_cakesters

  has_many :pledges
  
  validates :name, :email, :phone, presence: true
  validates :email, email: true
  
  validates :mission, :manager_name, :manager_phone, :manager_title, :manager_email, :about, presence: true, unless: :new_record?
  validates :manager_email, email: true, unless: :new_record?
  validates :website, format: {with: DOMAIN_NAME_REGEX, message: I18n.t('errors.url')}, unless: :new_record?

  accepts_nested_attributes_for :location, update_only: true, reject_if: :all_blank
  validates_associated :location

  scope :latest, ->{ order(created_at: :desc) }

  scope :with_location, ->{ eager_load(:location) }

  delegate :city, :state, :state_code, :country, :address, to: :location

  after_initialize do
    self.build_location if self.new_record?
  end

  COMMISSIONS = (5..50).step(5).to_a

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
    text :mission, :website, :email, :manager_name, :manager_email, :manager_phone
    text :city, :state_code

    text :zip_code do
      location.zip_code  
    end

    # text :pledges_names do
    #   pledges.map {|p| p.name }
    # end

    text :causes
    string :scopes, multiple: true
    string :causes, multiple: true

    string :zip_code do
      location.zip_code  
    end

    time :created_at
  end

  def self.popular
    self.with_picture.with_location.latest.first(12)
  end

  #Notify profile update
  def notify_update
    users.each do |user|
      UserNotification.cakester_profile_updated(self.id, user.id).deliver if user.cakester_email_setting.public_profile_change
    end
  end

  #Campaigns
  def add_campaign(campaign)
    self.campaigns << campaign
    self.save
  end
end
