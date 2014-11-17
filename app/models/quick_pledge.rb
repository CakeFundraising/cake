class QuickPledge < ActiveRecord::Base
  include Formats
  include Statusable
  include Picturable

  has_statuses :incomplete, :confirmed, :past

  belongs_to :campaign, touch: true
  belongs_to :sponsorable, polymorphic: true
  has_one :fundraiser, through: :campaign

  delegate :active?, to: :campaign

  scope :latest, ->{ order(created_at: :desc) }
  scope :with_campaign, ->{ eager_load(:campaign) }
  scope :highest, ->{ order(total_amount_cents: :desc, donation_per_click_cents: :desc) }

  validates :name, :website_url, :campaign, presence: true
  validates :website_url, format: {with: DOMAIN_NAME_REGEX, message: I18n.t('errors.url')}
  validates :donation_per_click, numericality: {greater_than: 0, less_than_or_equal_to: 1000}
  validates :total_amount, numericality: {greater_than_or_equal_to: 50}
  validates :terms, acceptance: true, if: :new_record?

  validate :max_amount, :total_amount_greater_than_donation_per_click
  validate :decreased_amounts, if: :persisted?

  monetize :donation_per_click_cents
  monetize :total_amount_cents

  before_create do
    self.status = :confirmed
  end

  private

  def max_amount
    if campaign and campaign.custom_pledge_levels
      max = campaign.sponsor_categories.maximum(:max_value_cents)
      errors.add(:total_amount, "This campaign allows offers up to $#{max/100}") if max < total_amount_cents
    end
  end

  def total_amount_greater_than_donation_per_click
    errors.add(:total_amount, "Must be greater than amount per click.") if donation_per_click_cents > total_amount_cents
  end

  def decreased_amounts
    errors.add(:donation_per_click, "You can only increase this value after you create the pledge.") if self.changes.key?('donation_per_click_cents') and self.changes['donation_per_click_cents'].last < self.changes['donation_per_click_cents'].first 
    errors.add(:total_amount, "You can only increase this value after you create the pledge.") if self.changes.key?('total_amount_cents') and self.changes['total_amount_cents'].last < self.changes['total_amount_cents'].first
  end
end
