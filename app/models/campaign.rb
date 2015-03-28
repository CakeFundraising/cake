class Campaign < ActiveRecord::Base
  include Cause
  include Scope
  include Statusable
  include Analytics
  include Picturable
  include Screenshotable
  include SponsorAlias
  include CakesterCommissionable

  has_statuses :incomplete, :pending, :launched, :past
  has_statuses :unprocessed, :missed_launch, column_name: :processed_status

  attr_accessor :step

  belongs_to :fundraiser
  belongs_to :exclusive_cakester, class_name:'Cakester', foreign_key: :exclusive_cakester_id

  has_one :exclusive_cakester_request, ->(c){ from_campaign(c) }, through: :exclusive_cakester, class_name:'CakesterRequest', source: :cakester_requests
  
  has_one :video, as: :recordable, dependent: :destroy
  has_many :pledge_requests, dependent: :destroy
  has_many :pledges, dependent: :destroy
  has_many :quick_pledges, dependent: :destroy
  has_many :invoices, through: :pledges
  has_many :sponsors, through: :pledges, source_type: 'Sponsor'
  has_many :fr_sponsors, through: :pledges, source_type: 'FrSponsor'

  has_many :sponsor_categories, validate: false, dependent: :destroy do
    # returns a hash: {category_name: (range_of_category) }
    def levels
      Hash[
        map{|sc| [sc.name, (sc.min_value_cents..sc.max_value_cents) ] }
      ]
    end
  end

  has_many :impressions, as: :impressionable

  has_one :cakester_commission_setting, as: :commissionable, class_name:'CakesterCommission'
  has_many :cakester_requests, dependent: :destroy
  has_many :campaign_cakesters, dependent: :destroy
  has_many :cakesters, through: :campaign_cakesters

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
    past.with_invoices.select{|c| c.invoices.normal.any? && c.invoices.present? && c.invoices.map(&:status).uniq == ['paid'] }
  }
  scope :with_outstanding_invoices, ->{ 
    past.with_invoices.select{|c| c.invoices.normal.any? && c.invoices.present? && c.invoices.map(&:status).include?('due_to_pay') }
  }
  scope :with_cakester_requests, ->{ eager_load(:cakester_requests) }
  scope :with_campaign_cakesters, ->{ eager_load(:campaign_cakesters) }

  scope :latest, ->{ order('campaigns.created_at DESC') }

  scope :hero, ->{ where(hero: true) }
  scope :not_hero, ->{ where(hero: false) }

  scope :uses_cakester, ->{ where(uses_cakester: true) }
  scope :any_cakester, ->{ where(any_cakester: true) }
  
  #Solr
  searchable do
    text :title, boost: 5
    text :headline, boost: 5
    text :story, :mission, :main_cause

    text :fundraiser do
      fundraiser.name
    end

    text :zip_code do
      fundraiser.location.zip_code  
    end

    text :city do
      fundraiser.location.city  
    end

    text :state_code do
      fundraiser.location.state_code  
    end

    boolean :tax_exempt do
      fundraiser.tax_exempt
    end

    boolean :active, using: :active?
    boolean :visible
    boolean :uses_cakester
    boolean :any_cakester

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
  def rank_levels(pledges_status=:accepted)
    obj = self
    sponsor_categories.levels.each do |name, range|
      class_eval do
        define_method "#{name}_pledges" do
          CampaignPledgeDecorator.decorate_collection( obj.pledges.send(pledges_status).total_amount_in(range).order(total_amount_cents: :desc, amount_per_click_cents: :desc) )
        end 
      end
    end
  end

  def accepted_pledges
    pledges.accepted.order(total_amount_cents: :desc, amount_per_click_cents: :desc)
  end

  def raised(status=:accepted)
    pledges.send(status).map(&:total_charge).sum.to_f
  end

  def raised_by_status
    status = self.launched? ? :accepted : self.status
    pledges.send(status).map(&:total_charge).sum.to_f
  end

  def total_donation_per_click
    pledges.accepted.sum(:amount_per_click_cents)/100.0
  end

  def current_pledges_total
    pledges.accepted.sum(:total_amount_cents)/100
  end

  def current_average_donation
    return 0 unless pledges.accepted.any?
    (raised/pledges.accepted.count).floor
  end

  def pledges_thermometer
    (raised_by_status/goal.amount)*100 unless goal.amount == 0.0
  end

  def self.popular
    self.with_picture.with_pledges.not_past.not_incomplete.visible.latest.first(12)
  end

  #Status
  def active?
    end_date >= Date.today and status != 'past'
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

  def rollback_end
    pledges.each do |p|
      p.accepted!
      p.invoice.try(:destroy)
    end
    launched!
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

  #Hero Campaign
  def hero_pledge?
    self.hero ? pledges.accepted_or_past.any? : false
  end

  def hero_pledge
    pledges.accepted_or_past.first if hero_pledge?
  end

  def build_hero_pledge
    self.pledges.build(
      name: "Hero Pledge",
      mission: "Your mission",
      headline: "Sponsors - Tell your story here!",
      description:  "This is a Hero Campaign. That means your company or organization will be the only Sponsor. In this space, you can tell your story and share important information about your company or organization.",
      website_url: "http://yourdomain.com",
      status: :pending
    )
  end

  #Cakester
  def any_cakester?
    self.uses_cakester and self.any_cakester and self.exclusive_cakester_id.nil?
  end

  def exclusive_cakester?
    exclusive_cakester_id.present?
  end

  def cakesters_list
    self.cakester_requests.not_accepted.decorate + self.campaign_cakesters.decorate
  end

  def cakester_rate
    self.exclusive_cakester? ? self.exclusive_cakester_request.rate : self.cakester_commission_percentage
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
      end
    end
  end

end
