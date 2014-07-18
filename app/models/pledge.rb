class Pledge < ActiveRecord::Base
  include Statusable
  include Formats
  has_statuses :pending, :accepted, :rejected, :past
  has_statuses :unprocessed, :notified_fully_subscribed, column_name: :processed_status

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
  delegate :active?, to: :campaign

  accepts_nested_attributes_for :picture, update_only: true, reject_if: :all_blank
  accepts_nested_attributes_for :video, update_only: true, reject_if: proc {|attrs| attrs[:url].blank? }
  accepts_nested_attributes_for :coupons, reject_if: proc {|attrs| attrs[:title].blank? }, allow_destroy: true
  accepts_nested_attributes_for :sweepstakes, reject_if: proc {|attrs| attrs[:title].blank? }, allow_destroy: true

  monetize :amount_per_click_cents
  monetize :total_amount_cents

  validates :amount_per_click, numericality: {greater_than: 0, less_than_or_equal_to: 1000}
  validates :total_amount, numericality: {greater_than: 0}

  validates :amount_per_click, :total_amount, :campaign, :website_url, presence: true
  validates :website_url, format: {with: DOMAIN_NAME_REGEX, message: 'should include http:// or https://'}
  validates :mission, :headline, :description, :avatar, :banner, presence: true, if: :persisted?
  validates :terms, acceptance: true, if: :new_record?
  validate :max_amount, :total_amount_greater_than_amount_per_click
  validate :pledge_fully_subscribed, :decreased_amounts, if: :persisted?

  scope :active, ->{ accepted.includes(:campaign).where("campaigns.end_date >= ? AND campaigns.status != 'past'", Date.today).references(:campaign) }
  scope :pending_or_rejected, ->{ where("status = ? OR status = ?", :pending, :rejected) }
  
  scope :fundraiser, ->(fr){ joins(:campaign).where("campaigns.fundraiser_id = ?", fr) }
  scope :sponsor, ->(sponsor){ where(sponsor_id: sponsor.id) }

  scope :total_amount_in, ->(range){ where(total_amount_cents: range) }

  scope :fully_subscribed, ->{ not_notified_fully_subscribed.where("clicks_count >= max_clicks") }
  scope :not_fully_subscribed, ->{ where.not("clicks_count >= max_clicks") }

  after_initialize do
    if self.new_record?
      self.build_picture if picture.blank?
    end
  end

  before_save do
    self.max_clicks = self.current_max_clicks
  end

  #Actions
  def launch!
    delete_pledge_requests
    notify_launch if self.pending!
  end

  def delete_pledge_requests
    PledgeRequest.by_pledge(self).destroy_all
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

  def reject!(message)
    notify_rejection(message) if self.rejected!
  end

  def notify_rejection(message)
    sponsor.users.each do |user|
      PledgeNotification.rejected_pledge(self, user, message).deliver if user.sponsor_email_setting.reload.pledge_rejected
    end
  end

  #Clicks association
  def have_donated?(ip)
    clicks.exists?(request_ip: ip)
  end

  def current_max_clicks
    (self.total_amount_cents/self.amount_per_click_cents).floor
  end

  def fully_subscribed?
    self.reload.clicks_count >= self.max_clicks
  end

  def thermometer
    (clicks_count.to_f/max_clicks)*100
  end

  def notify_fully_subscribed
    fundraiser.users.each do |user|
      PledgeNotification.fr_pledge_fully_subscribed(self, user).deliver if user.fundraiser_email_setting.reload.pledge_fully_subscribed
    end
    sponsor.users.each do |user|
      PledgeNotification.sp_pledge_fully_subscribed(self, user).deliver if user.sponsor_email_setting.reload.pledge_fully_subscribed
    end
    update_attribute(:processed_status, :notified_fully_subscribed)
  end

  #Invoices
  def total_charge
    clicks_count*amount_per_click
  end

  def generate_invoice
    unless clicks_count.zero? or total_charge < Invoice::MIN_DUE
      create_invoice
      notify_invoice(invoice)
    end     
  end

  def create_invoice
    build_invoice(clicks: clicks_count, click_donation: amount_per_click, due: total_charge).save!
  end

  def notify_invoice(invoice)
    users = sponsor.users + fundraiser.users
    users.each do |user|
      InvoiceNotification.new_invoice(invoice, user).deliver
    end
  end

  #Increase
  def notify_increase
    fundraiser.users.each do |user|
      PledgeNotification.pledge_increased(self, user).deliver if user.fundraiser_email_setting.reload.pledge_increased
    end
  end

  def increase_request!
    notify_increase_request
    update_attribute(:increase_requested, true)
  end

  def notify_increase_request
    sponsor.users.each do |user|
      PledgeNotification.pledge_increase_request(self, user).deliver if user.sponsor_email_setting.reload.pledge_increased
    end
  end

  private

  def max_amount
    if campaign and campaign.custom_pledge_levels
      max = campaign.sponsor_categories.maximum(:max_value_cents)
      errors.add(:total_amount, "This campaign allows offers up to $#{max/100}") if max < total_amount_cents
    end
  end

  def total_amount_greater_than_amount_per_click
    errors.add(:total_amount, "Must be greater than amount per click.") if amount_per_click_cents > total_amount_cents
  end

  def pledge_fully_subscribed
    if clicks.any? and fully_subscribed?
      errors.add(:clicks, "Pledge fully subscribed")
    end
  end

  def decreased_amounts
    errors.add(:amount_per_click, "You can only increase this value after you create the pledge.") if self.changes.key?('amount_per_click_cents') and self.changes['amount_per_click_cents'].last < self.changes['amount_per_click_cents'].first 
    errors.add(:total_amount, "You can only increase this value after you create the pledge.") if self.changes.key?('total_amount_cents') and self.changes['total_amount_cents'].last < self.changes['total_amount_cents'].first
  end
end
