class HeroPledgeDecorator < CampaignPledgeDecorator
  def amount_per_click
    object.amount_per_click_cents == 0 ? "$XX" : super
  end

  def total_amount
    object.total_amount_cents == 0 ? "$XXXXX" : super
  end
end