class QuickPledge < Pledge
  before_create do
    self.status = :accepted
  end

  validates :name, :website_url, :campaign, :sponsor_id, :sponsor_type, presence: true
  validates :website_url, format: {with: DOMAIN_NAME_REGEX, message: I18n.t('errors.url')}
  validates :amount_per_click, numericality: {greater_than: 0, less_than_or_equal_to: 1000}
  validates :total_amount, numericality: {greater_than_or_equal_to: 50}
  validates :terms, acceptance: true, if: :new_record?

  validate :max_amount, :total_amount_greater_than_amount_per_click
  validate :decreased_amounts, if: :persisted?
end
