class Sponsor < ActiveRecord::Base
  include Cause
  include Scope
  include CauseRequirement

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
      UserNotification.sponsor_profile_updated(self, user).deliver if user.sponsor_email_setting.public_profile_change
    end
  end

  #Solr
  searchable do
    text :name, boost: 2
    text :mission, :phone, :website, :email, :manager_name, :manager_email, :manager_phone

    string :scopes, multiple: true
    string :causes, multiple: true

    string :zip_code do
      location.zip_code  
    end
  end

  def self.popular
    first(12)
  end

  def accepted_pledges
    pledges.accepted.eager_load(:fundraiser)
  end

  def fundraisers
    accepted_pledges.map(&:fundraiser)
  end

  #Statistic methods
  def total_donation
    (pledges.accepted.sum(:total_amount_cents)/100).to_money
  end

  def rank
  end

  #Invoices
  def outstanding_invoices
    invoices.outstanding.merge(pledges.past)
  end

  def past_invoices
    invoices.paid.merge(pledges.past)
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
end
