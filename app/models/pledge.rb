class Pledge < ActiveRecord::Base
  attr_accessor :step 
  
  belongs_to :sponsor
  belongs_to :campaign
  has_one :fundraiser, through: :campaign
  has_one :picture, as: :picturable, dependent: :destroy
  has_one :video, as: :recordable, dependent: :destroy
  has_many :coupons, dependent: :destroy, :inverse_of => :pledge
  has_many :sweepstakes, dependent: :destroy, :inverse_of => :pledge

  delegate :avatar, :banner, :avatar_caption, :banner_caption, to: :picture

  accepts_nested_attributes_for :picture, update_only: true, reject_if: :all_blank
  accepts_nested_attributes_for :video, update_only: true, reject_if: proc {|attrs| attrs[:url].blank? }
  accepts_nested_attributes_for :coupons, reject_if: proc {|attrs| attrs[:title].blank? }, allow_destroy: true
  accepts_nested_attributes_for :sweepstakes, reject_if: proc {|attrs| attrs[:title].blank? }, allow_destroy: true

  monetize :amount_per_click_cents
  monetize :total_amount_cents

  validates :amount_per_click, numericality: {only_integer: true, greater_than: 0, less_than_or_equal_to: 1000}
  validates :total_amount, numericality: {only_integer: true, greater_than: 0}

  validates :amount_per_click, :total_amount, :donation_type, :campaign, :website_url, presence: true
  validates :mission, :headline, :description, :avatar, :banner, presence: true, if: :persisted?
  validates :terms, acceptance: true, if: :new_record?

  DONATION_TYPES = ["Cash", "Goods & Services"]

  after_initialize do
    if self.new_record?
      self.build_picture if picture.blank?
    end
  end
end
