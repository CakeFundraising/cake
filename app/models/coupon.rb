class Coupon < ActiveRecord::Base
  include MerchandiseCategories
  attr_accessor :standard_terms

  belongs_to :pledge
  has_one :sponsor, through: :pledge

  mount_uploader :avatar, AvatarUploader
  validates_integrity_of  :avatar
  validates_processing_of :avatar

  mount_uploader :qrcode, QrCodeUploader
  validates_integrity_of  :qrcode
  validates_processing_of :qrcode

  monetize :unit_donation_cents
  monetize :total_donation_cents

  validates :unit_donation, numericality: {greater_than: 0, less_than_or_equal_to: 1000}, if: :extra_donation_pledge
  validates :total_donation, numericality: {greater_than: 0}, if: :extra_donation_pledge

  validates :title, :avatar, :qrcode, :description, :merchandise_categories, :expires_at, :pledge, presence: true

  scope :extra_donation_pledges, ->{ where(extra_donation_pledge: true) }
  scope :normal, ->{ where(extra_donation_pledge: false) }

  after_initialize do
    self.terms_conditions = I18n.t('application.terms_and_conditions.standard') if self.terms_conditions.blank?
  end

  searchable do
    text :title, boost: 2
    text :promo_code, :description
    text :sponsor do
      sponsor.name
    end

    string :merchandise_categories, multiple: true
    
    string :zip_code do
      sponsor.location.zip_code
    end
  end

  def self.popular
    last(12)
  end
end
