class Pledge < ActiveRecord::Base
  include Statusable
  include Formats
  include Picturable
  
  has_statuses :incomplete, :pending, :accepted, :rejected, :past
  has_statuses :unprocessed, :notified_fully_subscribed, column_name: :processed_status

  attr_accessor :step
  
  belongs_to :sponsor
  belongs_to :campaign, touch: true
  has_one :fundraiser, through: :campaign
  
  has_one :video, as: :recordable, dependent: :destroy
  has_one :invoice
  has_many :coupons, dependent: :destroy, :inverse_of => :pledge
  has_many :sweepstakes, dependent: :destroy, :inverse_of => :pledge

  has_many :clicks, dependent: :destroy
  has_many :click_browsers, through: :clicks, source: :browser

  has_many :impressions, as: :impressionable

  delegate :main_cause, :active?, to: :campaign

  accepts_nested_attributes_for :video, update_only: true, reject_if: proc {|attrs| attrs[:url].blank? }
  accepts_nested_attributes_for :sweepstakes, reject_if: proc {|attrs| attrs[:title].blank? }, allow_destroy: true

  monetize :amount_per_click_cents
  monetize :total_amount_cents

  validates :amount_per_click, numericality: {greater_than: 0, less_than_or_equal_to: 1000}
  validates :total_amount, numericality: {greater_than_or_equal_to: 50}

  validates :amount_per_click, :total_amount, :campaign, :website_url, presence: true

  validates :website_url, format: {with: DOMAIN_NAME_REGEX, message: I18n.t('errors.url')}
  validates :name, :mission, :headline, :description, presence: true, if: :persisted?
  validates :terms, acceptance: true, if: :new_record?
  validate :max_amount, :total_amount_greater_than_amount_per_click
  validate :decreased_amounts, if: :persisted?

  scope :active, ->{ accepted.includes(:campaign).where("campaigns.end_date >= ? AND campaigns.status != 'past'", Date.today).references(:campaign) }
  scope :pending_or_rejected, ->{ where("pledges.status = ? OR pledges.status = ?", :pending, :rejected) }
  scope :pending_or_past, ->{ where("pledges.status = ? OR pledges.status = ?", :pending, :past) }
  scope :accepted_or_past, ->{ where("pledges.status = ? OR pledges.status = ?", :accepted, :past) }
  scope :not_accepted_or_past, ->{ where.not("pledges.status = ? OR pledges.status = ?", :accepted, :past) }

  scope :fundraiser, ->(fr){ joins(:campaign).where("campaigns.fundraiser_id = ?", fr) }
  scope :sponsor, ->(sponsor){ where(sponsor_id: sponsor.id) }

  scope :total_amount_in, ->(range){ where(total_amount_cents: range) }

  scope :fully_subscribed, ->{ not_notified_fully_subscribed.where("clicks_count >= max_clicks") }
  scope :not_fully_subscribed, ->{ where.not("clicks_count >= max_clicks") }

  scope :highest, ->{ order(total_amount_cents: :desc, amount_per_click_cents: :desc) }
  scope :with_campaign, ->{ eager_load(:campaign) }

  scope :latest, ->{ order(created_at: :desc) }

  before_save do
    self.max_clicks = self.current_max_clicks
  end

 ### TODO
  ### EMI How Can we make these links dynamic rather than hardcoded?
  after_save do
    
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
      PledgeNotification.launch_pledge(self.id, user.id).deliver if user.fundraiser_email_setting.reload.new_pledge
    end
  end

  def accept!
    notify_approval if self.accepted!
  end

  def notify_approval
    sponsor.users.each do |user|
      PledgeNotification.accepted_pledge(self.id, user.id).deliver if user.sponsor_email_setting.reload.pledge_accepted
    end
  end

  def reject!(message)
    notify_rejection(message) if self.rejected!
  end

  def notify_rejection(message)
    sponsor.users.each do |user|
      PledgeNotification.rejected_pledge(self.id, user.id, message).deliver if user.sponsor_email_setting.reload.pledge_rejected
    end
  end

  #Clicks association
  def click_exists?(click)
    # We delegate click existance to browser existance
    click_browsers.equal_to(click.browser).any?
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
      PledgeNotification.fr_pledge_fully_subscribed(self.id, user.id).deliver if user.fundraiser_email_setting.reload.pledge_fully_subscribed
    end
    sponsor.users.each do |user|
      PledgeNotification.sp_pledge_fully_subscribed(self.id, user.id).deliver if user.sponsor_email_setting.reload.pledge_fully_subscribed
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
      InvoiceNotification.new_invoice(invoice.id, user.id).deliver
    end
  end

  #Increase
  def increase!
    update_attribute(:increase_requested, false)
    notify_increase
  end

  def notify_increase
    fundraiser.users.each do |user|
      PledgeNotification.pledge_increased(self.id, user.id).deliver if user.fundraiser_email_setting.reload.pledge_increased
    end
  end

  def increase_request!
    notify_increase_request
    update_attribute(:increase_requested, true)
  end

  def notify_increase_request
    sponsor.users.each do |user|
      PledgeNotification.pledge_increase_request(self.id, user.id).deliver if user.sponsor_email_setting.reload.pledge_increased
    end
  end

  ### Impressions
  def views_count
    impressions_count || 0
  end

  def engagement
    return 0 if views_count.zero?
    (clicks_count/views_count)
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

  def decreased_amounts
    errors.add(:amount_per_click, "You can only increase this value after you create the pledge.") if self.changes.key?('amount_per_click_cents') and self.changes['amount_per_click_cents'].last < self.changes['amount_per_click_cents'].first 
    errors.add(:total_amount, "You can only increase this value after you create the pledge.") if self.changes.key?('total_amount_cents') and self.changes['total_amount_cents'].last < self.changes['total_amount_cents'].first
  end
end
