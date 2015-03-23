class CampaignCommission < Campaign
  def self.popular
    self.with_picture.not_past.not_incomplete.uses_cakester.any_cakester.visible.latest.first(12)
  end
end