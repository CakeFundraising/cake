class Coupon < ActiveRecord::Base
  include MerchandiseCategories
  include Picturable
  include ExtraClickable
  
  belongs_to :pledge
  has_one :sponsor, through: :pledge, source_type: 'Sponsor'
  has_one :campaign, through: :pledge

  monetize :unit_donation_cents, disable_validation: true
  monetize :total_donation_cents, disable_validation: true

  validates :title, :description, :merchandise_categories, :expires_at, :pledge, presence: true
  validate :extra_donation_pledge_validation

  scope :extra_donation_pledges, ->{ where(extra_donation_pledge: true) }
  scope :normal, ->{ where(extra_donation_pledge: false) }

  scope :not_past, ->{ eager_load(:pledge).where("pledges.status != 'past'") }
  scope :active, ->{ eager_load(:pledge).where("pledges.status = 'accepted'") }

  scope :latest, ->{ order(created_at: :desc) }

  delegate :city, :state_code, to: :sponsor

  after_initialize do
    self.terms_conditions = I18n.t('application.terms_and_conditions.coupons')
  end

  after_create do
    self.pledge.update_attribute(:show_coupons, true) unless self.pledge.show_coupons
  end

  searchable do
    text :title, boost: 2
    text :promo_code, :description
    text :city, :state_code

    text :sponsor do
      sponsor.name
    end

    text :pledge do
      pledge.name
    end

    text :campaign do
      campaign.title
    end

    string :merchandise_categories, multiple: true
    
    string :zip_code do
      sponsor.location.zip_code
    end

    string :status do
      pledge.status
    end

    time :created_at
  end

  def self.popular
    self.active.latest.first(12)
  end

  def active?
    self.pledge.active?
  end

  def extra_donation_pledge_validation
    if self.extra_donation_pledge
      errors.add(:unit_donation, "This must be a number") unless self.unit_donation_cents.is_a?(Fixnum)
      errors.add(:total_donation, "This must be a number") unless self.total_donation_cents.is_a?(Fixnum)

      errors.add(:unit_donation, "This must be greater than $0") unless self.unit_donation_cents > 0
      errors.add(:total_donation, "This must be greater than $0") unless self.total_donation_cents > 0

      errors.add(:total_donation, "Must be greater than previous value.") if self.unit_donation_cents >= self.total_donation_cents
    end
  end
end
