class HeroDecorator < CampaignDecorator
  def instance_name
    "hero"
  end

  def class_name
    "Campaign"  
  end

  def self.primary_key
    'id'
  end

  def self.base_class
    Campaign
  end
end