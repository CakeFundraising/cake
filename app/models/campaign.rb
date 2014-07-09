class Campaign < ActiveRecord::Base
  include Cause
  include Scope
  include Statusable

  has_statuses :not_launched, :launched, :past
  has_statuses :unprocessed, :missed_launch, column_name: :processed_status

  attr_accessor :step 

  belongs_to :fundraiser
  has_one :picture, as: :picturable, dependent: :destroy
  has_one :video, as: :recordable, dependent: :destroy
  has_many :pledge_requests, dependent: :destroy
  has_many :pledges, dependent: :destroy
  has_many :invoices, through: :pledges
  has_many :sponsors, through: :pledges

  has_many :sponsor_categories, validate: false, dependent: :destroy do
    # returns a hash: {category_name: (range_of_category) }
    def levels
      Hash[
        map{|sc| [sc.name, (sc.min_value_cents..sc.max_value_cents) ] }
      ]
    end
  end

  has_many :direct_donations, dependent: :destroy

  accepts_nested_attributes_for :picture, update_only: true, reject_if: :all_blank
  accepts_nested_attributes_for :video, update_only: true, reject_if: proc {|attrs| attrs[:url].blank? }
  accepts_nested_attributes_for :sponsor_categories, allow_destroy: true, reject_if: :all_blank

  validates :title, :launch_date, :end_date, :causes, :scopes, :fundraiser, presence: true
  validates :mission, :headline, :story, presence: true, if: :persisted?
  validates_associated :sponsor_categories, if: :custom_pledge_levels
  validates_associated :picture

  validates :sponsor_categories, length: {is: SponsorCategory::LENGTH}, if: ->{ self.custom_pledge_levels and self.persisted? }
  validate :sponsor_categories_overlapping, :sponsor_categories_max_min_value, if: :custom_pledge_levels

  delegate :avatar, :banner, :avatar_caption, :banner_caption, to: :picture

  scope :to_end, ->{ where("end_date <= ?", Date.today) }
  scope :active, ->{ where("end_date >= ?", Date.today) }
  scope :unlaunched, ->{ not_launched.not_missed_launch.where("launch_date < ?", Date.today) }

  scope :with_invoices, ->{ eager_load(:invoices) }
  scope :with_picture, ->{ eager_load(:picture) }

  scope :with_paid_invoices, ->{ 
    past.with_invoices.select{|c| c.invoices.present? && c.invoices.map(&:status).uniq == ['paid'] }
  }
  scope :with_outstanding_invoices, ->{ 
    past.with_invoices.reject{|c| c.invoices.blank? || c.invoices.map(&:status).include?('paid') }
  }

  after_initialize do
    if self.new_record?
      self.build_picture if picture.blank?
    end
  end

  after_create do
    unless self.sponsor_categories.any?
      self.sponsor_categories.create(name: 'Highest Sponsor')
      self.sponsor_categories.create(name: 'Medium Sponsor')
      self.sponsor_categories.create(name: 'Lowest Sponsor', min_value_cents: 5000)
    end
  end

  #Solr
  searchable do
    text :title, :headline, boost: 2
    text :story, :mission

    text :zip_code do
      fundraiser.location.zip_code  
    end

    boolean :tax_exempt do
      fundraiser.tax_exempt
    end

    boolean :active, using: :active?

    string :scopes, multiple: true
    string :causes, multiple: true
    
    string :zip_code do
      fundraiser.location.zip_code  
    end

    time :created_at

    integer :fundraiser_id
  end

  # Campaign pledges
  def rank_levels
    obj = self
    sponsor_categories.levels.each do |name, range|
      class_eval do
        define_method "#{name}_pledges" do
          obj.pledges.accepted.total_amount_in(range).order(total_amount_cents: :desc, amount_per_click_cents: :desc)
        end 
      end
    end
  end

  def accepted_pledges
    pledges.accepted.order('total_amount_cents DESC')
  end

  def raised
    pledges.accepted.map(&:current_amount).sum.to_f/100
  end

  def goal
    pledges.accepted.sum(:total_amount_cents)/100
  end

  def pledges_thermometer
    (raised/goal)*100
  end

  def self.popular
    self.order(created_at: :desc).first(12)
  end

  #Status
  def active?
    (launch_date..end_date).cover?(Date.today)
  end

  def past?
    end_date < Date.today
  end

  #Actions
  def end
    fundraiser.users.each do |user|
      CampaignNotification.campaign_ended(self, user).deliver if user.fundraiser_email_setting.campaign_end
    end
    #generate invoice
    pledges.accepted.each(&:generate_invoice)
    update_attribute(:status, :past)
  end

  def launch!
    notify_launch if update_attribute(:status, :launched)
  end

  def notify_launch
    sponsors.map(&:users).flatten.each do |user|
      CampaignNotification.campaign_launched(self, user).deliver if user.sponsor_email_setting.campaign_launch
    end
  end

  def missed_launch_date
    fundraiser.users.each do |user|
      CampaignNotification.fundraiser_missed_launch_date(self, user).deliver if user.fundraiser_email_setting.missed_launch_campaign
    end

    sponsors.map(&:users).flatten.each do |user|
      CampaignNotification.sponsor_missed_launch_date(self, user).deliver if user.sponsor_email_setting.missed_launch_campaign
    end

    update_attribute(:processed_status, :missed_launch)
  end

  private

  def sponsor_categories_max_min_value
    sponsor_categories.each do |sc|
      errors.add(:'sponsor_categories.max_value', "must be greater than Min value.") if sc.min_value_cents >= sc.max_value_cents
    end
  end

  def sponsor_categories_overlapping
    values = sponsor_categories.map{|sc| (sc.min_value_cents..sc.max_value_cents) }
    values.each_with_index do |v, i|
      errors.add(:sponsor_categories, "The max and min values must not overlap.") if values[i+1].present? and values[i].overlaps?values[i+1]
    end
  end
end
