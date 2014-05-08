class Pledge < ActiveRecord::Base
  include Statusable
  has_statuses :pending, :accepted, :rejected

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

  validates :amount_per_click, numericality: {greater_than: 0, less_than_or_equal_to: 1000}
  validates :total_amount, numericality: {greater_than: 0}

  validates :amount_per_click, :total_amount, :donation_type, :campaign, :website_url, presence: true
  validates :mission, :headline, :description, :avatar, :banner, presence: true, if: :persisted?
  validates :terms, acceptance: true, if: :new_record?

  DONATION_TYPES = ["Cash", "Goods & Services"]

  scope :active, ->{ accepted.includes(:campaign).where("? BETWEEN campaigns.launch_date AND campaigns.end_date", Date.today).references(:campaign) }
  scope :past, ->{ accepted.includes(:campaign).where("campaigns.end_date < ?", Date.today).references(:campaign) }
  
  scope :fundraiser, ->(fr){ joins(:campaign).where("campaigns.fundraiser_id = ?", fr) }
  scope :sponsor, ->(sponsor){ where(sponsor_id: sponsor.id) }

  after_initialize do
    if self.new_record?
      self.build_picture if picture.blank?
    end
  end

  #Actions
  def launch!
    notify_launch if self.pending!
  end

  def notify_launch
    fundraiser.users.each do |user|
      PledgeNotification.launch_pledge(self, user).deliver if user.fundraiser_email_setting.reload.new_pledge
    end
  end

  def accept!
    notify_approval if self.accepted!
  end

  def notify_approval
    sponsor.users.each do |user|
      PledgeNotification.accepted_pledge(self, user).deliver if user.sponsor_email_setting.reload.pledge_accepted
    end
  end

  def reject!
    notify_rejection if self.rejected!
  end

  def notify_rejection
    sponsor.users.each do |user|
      PledgeNotification.rejected_pledge(self, user).deliver if user.sponsor_email_setting.reload.pledge_rejected
    end
  end
end
