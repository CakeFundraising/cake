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
    if self.new_record?
      self.build_location
    end
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
end
