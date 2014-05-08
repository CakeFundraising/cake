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
  has_many :sponsors, through: :pledges

  has_many :sponsor_categories, dependent: :destroy do
    # returns a hash: {category_name: (range_of_category) }
    def levels
      Hash[
        map{|sc| [sc.name, (sc.min_value_cents..sc.max_value_cents) ] }
      ]
    end
  end

  accepts_nested_attributes_for :picture, update_only: true, reject_if: :all_blank
  accepts_nested_attributes_for :video, update_only: true, reject_if: proc {|attrs| attrs[:url].blank? }
  accepts_nested_attributes_for :sponsor_categories, allow_destroy: true, reject_if: :all_blank

  validates :title, :launch_date, :end_date, :causes, :scopes, :headline, :story, :fundraiser, presence: true
  validates_associated :sponsor_categories, unless: :no_sponsor_categories
  validates_associated :picture

  delegate :avatar, :banner, :avatar_caption, :banner_caption, to: :picture

  scope :active, ->{where("? BETWEEN launch_date AND end_date", Date.today)}
  scope :past, ->{ where("end_date < ?", Date.today) }
  scope :unlaunched, ->{ inactive.where("launch_date < ?", Date.today) }

  after_initialize do
    if self.new_record?
      self.build_picture if picture.blank?
    end
  end

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
end
