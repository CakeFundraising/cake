class FrSponsor < ActiveRecord::Base
  include Formats
  include Picturable

  #attr_accessor :picture_permission

  belongs_to :fundraiser
  has_one :location, as: :locatable, dependent: :destroy

  delegate :city, :state, :state_code, :country, :address, to: :location

  validates :name, :email, :website_url, presence: :true
  validates :email, email: true
  validates_associated :location
  validates :website_url, format: {with: DOMAIN_NAME_REGEX, message: I18n.t('errors.url')}, unless: :new_record?
  #validates_acceptance_of :picture_permission

  accepts_nested_attributes_for :location, update_only: true, reject_if: :all_blank

  scope :latest, ->{ order(created_at: :desc) }

  after_initialize do
    if self.new_record?
      self.build_location
    end
  end
end
