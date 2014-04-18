class Coupon < ActiveRecord::Base
  attr_accessor :standard_terms
  attr_accessor :extra_donation_pledge

  belongs_to :pledge
  has_one :sponsor, through: :pledge

  mount_uploader :avatar, AvatarUploader
  validates_integrity_of  :avatar
  validates_processing_of :avatar

  mount_uploader :qrcode, QrCodeUploader
  validates_integrity_of  :qrcode
  validates_processing_of :qrcode

  validates :title, :avatar, :qrcode, :description, :expires_at, :pledge, presence: true

  after_initialize do
    self.terms_conditions = I18n.t('application.terms_and_conditions.standard') if self.terms_conditions.blank?
  end
end
