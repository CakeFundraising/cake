class HeroDecorator < CampaignDecorator
  decorates :campaign

  def instance_name
    "hero"
  end
end