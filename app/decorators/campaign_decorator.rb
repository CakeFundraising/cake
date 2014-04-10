class CampaignDecorator < Draper::Decorator
  delegate_all
  decorates_association :video
end
