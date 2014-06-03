class Campaign < ActiveRecord::Base
  include Cause
  include Scope
  include Statusable

  has_statuses :inactive, :live

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
  validate :sponsor_categories_overlapping, :sponsor_categories_max_min_value, if: :custom_pledge_levels

  delegate :avatar, :banner, :avatar_caption, :banner_caption, to: :picture

  scope :active, ->{ live.where("? BETWEEN launch_date AND end_date", Date.today) }
  scope :past, ->{ where("end_date < ?", Date.today) }
  scope :unlaunched, ->{ inactive.where("launch_date < ?", Date.today) }

  scope :with_invoices, ->{ eager_load(:invoices) }

  scope :with_paid_invoices, ->{ 
    past.with_invoices.select{|c| c.invoices.present? && c.invoices.map(&:status).uniq == ['paid'] }
    # past.select('DISTINCT "campaigns".*').joins('LEFT OUTER JOIN "pledges" ON "pledges"."campaign_id" = "campaigns"."id" LEFT OUTER JOIN "invoices" ON "invoices"."pledge_id" = "pledges"."id" AND "invoices"."status" = \'due_to_pay\' OR "invoices"."status" = \'in_arbitration\'').where('"invoices"."pledge_id" IS NULL')
  }
  scope :with_outstanding_invoices, ->{ 
    past.with_invoices.reject{|c| c.invoices.blank? || c.invoices.map(&:status).include?('paid') }
    # past.select('DISTINCT "campaigns".*').joins('LEFT OUTER JOIN "pledges" ON "pledges"."campaign_id" = "campaigns"."id" INNER JOIN "invoices" ON "invoices"."pledge_id" = "pledges"."id" AND "invoices"."status" = \'paid\'').where('"invoices"."pledge_id" IS NULL')
  }

  after_initialize do
    if self.new_record?
      self.build_picture if picture.blank?
    end
  end

  # Campaign pledges
  def rank_levels
    obj = self
    sponsor_categories.levels.each do |name, range|
      class_eval do
        define_method "#{name}_pledges" do
          obj.pledges.accepted.total_amount_in(range).order('total_amount_cents DESC')
        end 
      end
    end
  end

  def accepted_pledges
    pledges.accepted.order('total_amount_cents DESC')
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
  end

  def launch!
    notify_launch if update_attribute(:status, :live)
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
