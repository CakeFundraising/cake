class Pledge < ActiveRecord::Base
  include Statusable
  has_statuses :pending, :accepted, :rejected

  attr_accessor :step 
  
  belongs_to :sponsor
  belongs_to :campaign
  has_one :fundraiser, through: :campaign
  has_one :picture, as: :picturable, dependent: :destroy
  has_one :video, as: :recordable, dependent: :destroy
  has_one :invoice
  has_many :coupons, dependent: :destroy, :inverse_of => :pledge
  has_many :sweepstakes, dependent: :destroy, :inverse_of => :pledge
  has_many :clicks, dependent: :destroy

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
  validate :max_amount

  DONATION_TYPES = ["Cash", "Goods & Services"]

  scope :active, ->{ accepted.includes(:campaign).where("? BETWEEN campaigns.launch_date AND campaigns.end_date", Date.today).references(:campaign) }
  scope :past, ->{ accepted.includes(:campaign).where("campaigns.end_date < ?", Date.today).references(:campaign) }
  
  scope :fundraiser, ->(fr){ joins(:campaign).where("campaigns.fundraiser_id = ?", fr) }
  scope :sponsor, ->(sponsor){ where(sponsor_id: sponsor.id) }

  scope :total_amount_in, ->(range){ where(total_amount_cents: range) }

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

  #Clicks association
  def have_donated?(ip)
    clicks.exists?(request_ip: ip)
  end

  #Invoices
  def generate_invoice
    invoice = self.create_invoice(clicks: clicks_count, click_donation: amount_per_click, due: clicks_count*amount_per_click)
    notify_invoice(invoice)    
  end

  def notify_invoice(invoice)
    sponsor.users.each do |user|
      InvoiceNotification.new_invoice(invoice, user).deliver
    end
  end

  private

  def max_amount
    if campaign and campaign.sponsor_categories.present?
      max = campaign.sponsor_categories.maximum(:max_value_cents)
      errors.add(:total_amount, "This campaign allows offers up to $#{max/100}") if max < total_amount_cents
    end
  end
end
