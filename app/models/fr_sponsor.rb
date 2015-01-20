class FrSponsor < ActiveRecord::Base
  include Formats

  belongs_to :fundraiser
  has_one :location, as: :locatable, dependent: :destroy
  has_many :quick_pledges, as: :sponsor, dependent: :destroy
  has_many :campaigns, through: :quick_pledges

  delegate :city, :state, :state_code, :country, :address, to: :location

  validates :name, :email, presence: :true
  validates :email, email: true
  validates_associated :location

  accepts_nested_attributes_for :location, update_only: true, reject_if: :all_blank

  scope :latest, ->{ order(created_at: :desc) }

  after_initialize do
    if self.new_record?
      self.build_location
    end
  end
end
