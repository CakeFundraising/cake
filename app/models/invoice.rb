class Invoice < ActiveRecord::Base
  include Statusable
  include Fees

  has_statuses :due_to_pay, :paid

  MIN_DUE = 0.5

  belongs_to :pledge, touch: true
  has_one :campaign, through: :pledge
  has_one :fundraiser, through: :campaign
  has_one :sponsor, through: :pledge, source_type: 'Sponsor'

  has_one :payment, as: :item
  has_many :charges, through: :payment

  monetize :click_donation_cents
  monetize :due_cents
  monetize :cakester_commission_cents

  scope :outstanding, ->{ where.not(status: :paid) }
  scope :latest, ->{ order(created_at: :desc) }

  scope :quick, ->{ where(type: 'QpInvoice') }
  scope :normal, ->{ where(type: nil) }

  delegate :bonus_clicks_count, to: :pledge

  def payable?
    self.due_cents > 50
  end

  def self.create_from_pledge!(pledge)
    status = (pledge.total_charge < MIN_DUE) ? :paid : :due_to_pay
    
    pledge.build_invoice(
      clicks: pledge.clicks_count, 
      click_donation: pledge.amount_per_click, 
      due: pledge.total_charge,
      fees_cents: Invoice.calculate_fees(pledge.total_charge_cents),
      net_amount_cents: Invoice.fr_net_amount(pledge),
      cakester_rate: pledge.cakester_rate,
      cakester_commission_cents: Invoice.calculate_cakester_commission(pledge),
      status: status
    ).save!
  end

  protected

  def self.fr_net_amount(pledge)
    net_amount = self.net_amount(pledge.total_charge_cents)
    (net_amount*((100-pledge.cakester_rate).to_f/100)).round
  end

  def self.calculate_cakester_commission(pledge)
    net_amount = self.net_amount(pledge.total_charge_cents)
    commission = (net_amount*(pledge.cakester_rate.to_f/100)).round
    net_commission = (commission*(1-Cake::CAKESTER_FEE)).round
    net_commission
  end

end
