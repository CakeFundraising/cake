module ResqueSchedule

  class CampaignEnd 
    extend RetryJob

    def self.perform
      Campaign.past.each do |campaign|
        campaign.end
      end
    end
  end
  
end