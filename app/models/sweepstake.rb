class Sweepstake < ActiveRecord::Base
  attr_accessor :standard_terms

  belongs_to :pledge
  has_one :sponsor, through: :pledge

  mount_uploader :avatar, AvatarUploader
  validates_integrity_of  :avatar
  validates_processing_of :avatar

  validates :title, :avatar, :winners_quantity, :description, :terms_conditions, :claim_prize_instructions, :pledge, presence: true

  after_initialize do
    self.terms_conditions = I18n.t('application.terms_and_conditions.standard') if self.terms_conditions.blank?
  end
end
