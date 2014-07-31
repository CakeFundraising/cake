class Sponsor < ActiveRecord::Base
  include Cause
  include Scope
  include CauseRequirement
  include Formats

  belongs_to :manager, class_name: "User"
  has_one :location, as: :locatable, dependent: :destroy
  has_one :picture, as: :picturable, dependent: :destroy
  has_one :stripe_account, as: :account, dependent: :destroy
  has_many :users
  has_many :pledge_requests, dependent: :destroy
  has_many :pledges, dependent: :destroy
  has_many :campaigns, through: :pledges
  has_many :invoices, through: :pledges

  has_many :payments, as: :payer, dependent: :destroy

  validates :name, :email, :phone, presence: true
  validates :email, email: true
  
  validates :mission, :manager_name, :manager_phone, :manager_title, :customer_demographics, :manager_email, presence: true, unless: :new_record?
  validates :manager_email, email: true, unless: :new_record?
  validates :website, format: {with: DOMAIN_NAME_REGEX, message: 'should include http:// or https://'}, unless: :new_record?

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

  scope :rank, ->{ eager_load(:invoices).where(invoices: {status: "paid"}).order("invoices.due_cents DESC") }
  scope :local_rank, ->(zip_code){ eager_load(:invoices, :location).where(locations: {zip_code: zip_code}, invoices: {status: "paid"}).order("invoices.due_cents DESC") } 

  #Solr
  searchable do
    text :name, boost: 2
    text :mission, :phone, :website, :email, :manager_name, :manager_email, :manager_phone

    string :scopes, multiple: true
    string :causes, multiple: true

    string :zip_code do
      location.zip_code  
    end

    time :created_at
  end

  def self.popular
    self.order(created_at: :desc).first(12)
  end

  def accepted_pledges
    pledges.accepted.eager_load(:fundraiser)
  end

  def fundraisers
    accepted_pledges.map(&:fundraiser).uniq
  end

  #### Statistic methods #####
  def total_donation
    invoices.paid.sum(:due_cents).to_i
  end

  def total_clicks
    pledges.accepted_or_past.sum(:clicks_count).to_i
  end

  def rank
    Sponsor.rank.find_index(self) + 1
  end

  def local_rank
    Sponsor.local_rank(self.location.zip_code).find_index(self) + 1
  end

  def pledges_count
    pledges.accepted_or_past.count
  end

  def any_pledges?
    pledges.accepted_or_past.any?
  end

  # Averages
  def average_pledge
    (pledges.accepted_or_past.sum(:total_amount_cents)/pledges_count) if any_pledges?
  end

  def average_donation
    (total_donation/invoices.paid.count) if invoices.paid.any? 
  end

  def average_donation_per_click
    (pledges.accepted_or_past.sum(:amount_per_click_cents)/pledges_count) if any_pledges?
  end

  def average_clicks_per_pledge
    (total_clicks/pledges_count).floor if any_pledges?
  end

  def top_pledges(limiter)
    pledges.accepted_or_past.highest.first(limiter)
  end

  def top_causes # {cause_name: pledge_amount}
    top_causes = {}
    top_pledges(3).each do |pledge|
      top_causes.store(pledge.main_cause, pledge.total_amount) unless top_causes.has_key?(pledge.main_cause)
    end
    top_causes
  end

  #### SP dashboard home
  def active_pledges_clicks_count
    pledges.active.sum(:clicks_count).to_i
  end

  def invoices_due
    outstanding_invoices.sum(:due_cents).to_i
  end

  #### Invoices
  def outstanding_invoices
    invoices.outstanding.merge(pledges.past)
  end

  def past_invoices
    invoices.paid.merge(pledges.past)
  end

  #### Stripe Account
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
      UserNotification.sponsor_profile_updated(self, user).deliver if user.sponsor_email_setting.public_profile_change
    end
  end
end
