namespace :cake do
  desc "Sends email notifications to ended campaign's fundraisers"
  task end_campaigns: :environment do
    Campaign.past.each do |campaign|
      campaign.end
    end
  end

  desc "Sends email notifications to fundraisers/sponsors of campaigns that have missed their launch date"
  task notify_missed_campaign_launch: :environment do
    Campaign.unlaunched.each do |campaign|
      campaign.missed_launch_date
    end
  end
end
