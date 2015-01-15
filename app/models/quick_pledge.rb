class QuickPledge < ActiveRecord::Base
  include Formats
  include Statusable
  include Picturable

  has_statuses :incomplete, :accepted, :past

  belongs_to :campaign, touch: true
  belongs_to :sponsorable, polymorphic: true
  has_one :fundraiser, through: :campaign

  has_many :clicks, -> { where(bonus: false) }, as: :pledge, class_name: 'Click', dependent: :destroy
  has_many :bonus_clicks, -> { where(bonus: true) }, as: :pledge, class_name: 'Click', dependent: :destroy
  has_many :unique_click_browsers, through: :clicks, source: :browser
  has_many :bonus_click_browsers, through: :bonus_clicks, source: :browser

  delegate :active?, to: :campaign

  scope :latest, ->{ order(created_at: :desc) }
  scope :with_campaign, ->{ eager_load(:campaign) }
  scope :highest, ->{ order(total_amount_cents: :desc, amount_per_click_cents: :desc) }
  scope :total_amount_in, ->(range){ where(total_amount_cents: range) }

  validates :name, :website_url, :campaign, presence: true
  validates :website_url, format: {with: DOMAIN_NAME_REGEX, message: I18n.t('errors.url')}
  validates :amount_per_click, numericality: {greater_than: 0, less_than_or_equal_to: 1000}
  validates :total_amount, numericality: {greater_than_or_equal_to: 50}
  validates :terms, acceptance: true, if: :new_record?

  validate :max_amount, :total_amount_greater_than_amount_per_click
  validate :decreased_amounts, if: :persisted?

  monetize :amount_per_click_cents
  monetize :total_amount_cents

  before_save do
    self.max_clicks = self.current_max_clicks
  end

  before_create do
    self.status = :accepted
  end

  alias_method :sponsor, :sponsorable

  def click_exists?(click)
    unique_click_for_browser?(click.browser) # We delegate click existance to browser existance
  end

  def unique_click_for_browser?(browser)
    browser.nil? ? false : unique_click_browsers.equal_to(browser).any?
  end

  def bonus_click_for_browser?(browser)
    browser.nil? ? false : bonus_click_browsers.equal_to(browser).any?
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
