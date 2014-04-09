module CampaignsHelper
  DONATIONS_SETTINGS = Campaign::DONATIONS_SETTINGS.map{|s| [I18n.t("formtastic.labels.campaign.show_donation.#{s}"), s] } 
end
