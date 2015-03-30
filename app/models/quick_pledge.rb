class QuickPledge < Pledge
  has_one :invoice, class_name: 'QpInvoice', foreign_key: :pledge_id

  before_create do
    self.status = :accepted
  end

  after_create :notify_sponsor

  validates :name, :website_url, :campaign, :sponsor_id, :sponsor_type, presence: true
  validates :website_url, format: {with: DOMAIN_NAME_REGEX, message: I18n.t('errors.url')}
  validates :amount_per_click, numericality: {greater_than: 0, less_than_or_equal_to: 1000}
  validates :total_amount, numericality: {greater_than_or_equal_to: 50}
  validates :terms, acceptance: true, if: :new_record?

  validate :max_amount, :total_amount_greater_than_amount_per_click, :not_hero_campaign

  def create_invoice
    build_invoice(clicks: clicks_count, click_donation: amount_per_click, due: total_charge).save!
  end

  private

  def notify_sponsor
    PledgeNotification.qp_created(self.id).deliver
  end

  def not_hero_campaign
    if self.campaign.present?
      errors.add(:campaign, "Hero campaigns cannot have quick pledges.") if self.campaign.hero
    end
  end
end
