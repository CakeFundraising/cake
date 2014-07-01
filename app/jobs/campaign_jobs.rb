module ResqueSchedule

  class CampaignEnd 
    extend Resque::Plugins::Retry

    @retry_limit = 3
    @retry_delay = 60

    def self.perform
      Campaign.past.each do |campaign|
        campaign.end
      end
    end
  end
  
  class CampaignMissedLaunch
    extend Resque::Plugins::Retry

    @retry_limit = 3
    @retry_delay = 60

    def self.perform
      Campaign.unlaunched.each do |campaign|
        campaign.missed_launch_date
      end
    end
  end

end