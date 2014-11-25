class Campaign < ActiveRecord::Base
  include Cause
  include Scope
  include Statusable
  include Analytics
  include Picturable
  include Screenshotable

  has_statuses :incomplete, :pending, :launched, :past
  has_statuses :unprocessed, :missed_launch, column_name: :processed_status

  attr_accessor :step 

  belongs_to :fundraiser
  
  has_one :video, as: :recordable, dependent: :destroy
  has_many :pledge_requests, dependent: :destroy
  has_many :pledges, dependent: :destroy
  has_many :quick_pledges, dependent: :destroy
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
  has_many :impressions, as: :impressionable

  accepts_nested_attributes_for :video, update_only: true, reject_if: proc {|attrs| attrs[:url].blank? }
  accepts_nested_attributes_for :sponsor_categories, allow_destroy: true, reject_if: :all_blank
  
  monetize :goal_cents

  validates :goal, numericality: {greater_than: 0}

  validates :title, :launch_date, :end_date, :main_cause, :scopes, :fundraiser, :goal, presence: true
  validates :mission, :headline, :story, presence: true, if: :persisted?
  validates_associated :sponsor_categories, if: :custom_pledge_levels

  validate :sponsor_categories_max_min_value, if: :custom_pledge_levels

  scope :to_end, ->{ not_past.where("end_date <= ?", Time.zone.now) }
  scope :active, ->{ not_past.where("end_date > ?", Time.zone.now) }
  scope :unlaunched, ->{ pending.not_missed_launch.where("launch_date < ?", Time.zone.now) }

  scope :visible, ->{ where(visible: true) }
  scope :not_visible, ->{ where(visible: false) }

  scope :with_pledges, ->{ eager_load(:pledges) }
  scope :with_invoices, ->{ eager_load(:invoices) }
  scope :with_paid_invoices, ->{ 
    past.with_invoices.select{|c| c.invoices.present? && c.invoices.map(&:status).uniq == ['paid'] }
  }
  scope :with_outstanding_invoices, ->{ 
    past.with_invoices.select{|c| c.invoices.present? && c.invoices.map(&:status).include?('due_to_pay') }
  }

  scope :latest, ->{ order('campaigns.created_at DESC') }
  
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
    boolean :visible

    string :scopes, multiple: true
    string :main_cause
    
    string :zip_code do
      fundraiser.location.zip_code  
    end

    string :status

    time :created_at

    integer :fundraiser_id
  end

  #Relations
  def relevant_sponsors
    sponsors.merge(pledges.accepted_or_past)
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
    pledges.accepted.order(total_amount_cents: :desc, amount_per_click_cents: :desc)
  end

  def raised
    pledges.accepted.map(&:total_charge).sum.to_f
  end

  def current_pledges_total
    pledges.accepted.sum(:total_amount_cents)/100
  end

  def current_average_donation
    return 0 unless pledges.accepted.any?
    (raised/pledges.accepted.count).floor
  end

  def pledges_thermometer
    (raised/goal.amount)*100 unless goal.amount == 0.0
  end

  def self.popular
    self.with_picture.with_pledges.not_past.not_incomplete.visible.latest.first(12)
  end

  #Status
  def active?
    end_date >= Date.today and status != :past
  end

  #Actions
  def end
    pledges.accepted.each(&:generate_invoice)
    pledges.each(&:past!)
    past!
    notify_end
  end

  def notify_end
    fundraiser.users.each do |user|
      CampaignNotification.campaign_ended(self.id, user.id).deliver if user.fundraiser_email_setting.campaign_end
    end
  end

  def launch!
    notify_launch if self.launched! and self.update_attribute(:visible, true)
  end

  def notify_launch
    sponsors.map(&:users).flatten.each do |user|
      CampaignNotification.campaign_launched(self.id, user.id).deliver if user.sponsor_email_setting.campaign_launch
    end
  end

  def missed_launch_date
    fundraiser.users.each do |user|
      CampaignNotification.fundraiser_missed_launch_date(self.id, user.id).deliver if user.fundraiser_email_setting.missed_launch_campaign
    end

    sponsors.map(&:users).flatten.each do |user|
      CampaignNotification.sponsor_missed_launch_date(self.id, user.id).deliver if user.sponsor_email_setting.missed_launch_campaign
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
    range = Proc.new {|object| object.min_value_cents..object.max_value_cents }

    sponsor_categories.each_with_index do |sc, i|
      if sponsor_categories[i+1].present?
        current_range = range.call sc
        next_range = range.call(sponsor_categories[i+1])

        errors.add(:sponsor_categories, "The max and min values must not overlap.") if current_range.overlaps?(next_range)
        # if sc.persisted? and sponsor_categories[i+1].persisted?
        # end
      end
    end
  end

end
