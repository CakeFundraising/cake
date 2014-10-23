class Coupon < ActiveRecord::Base
  include MerchandiseCategories
  include Picturable
  
  #attr_accessor :standard_terms

  belongs_to :pledge
  has_one :sponsor, through: :pledge

  monetize :unit_donation_cents
  monetize :total_donation_cents

  validates :unit_donation, numericality: {greater_than: 0, less_than_or_equal_to: 1000}, if: :extra_donation_pledge
  validates :total_donation, numericality: {greater_than: 0}, if: :extra_donation_pledge

  validates :title, :description, :merchandise_categories, :expires_at, :pledge, presence: true

  scope :extra_donation_pledges, ->{ where(extra_donation_pledge: true) }
  scope :normal, ->{ where(extra_donation_pledge: false) }

  scope :not_past, ->{ eager_load(:pledge).where("pledges.status != 'past'") }
  scope :active, ->{ eager_load(:pledge).where("pledges.status = 'accepted'") }

  scope :latest, ->{ order(created_at: :desc) }

  after_initialize do
    self.terms_conditions = I18n.t('application.terms_and_conditions.coupons')
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

    string :status do
      pledge.status
    end

    time :created_at
  end

  def self.popular
    self.active.latest.first(12)
  end
end
