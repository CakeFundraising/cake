class QpInvoice < Invoice
  belongs_to :pledge, class_name: 'QuickPledge', touch: true
  has_one :sponsor, through: :pledge, source_type: 'FrSponsor'

  def total_fees_cents
    (self.due_cents*Cake::APPLICATION_FEE).round
  end

  def total_fees
    (self.due*Cake::APPLICATION_FEE).round
  end
end