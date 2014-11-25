module ResqueSchedule
  
  class PledgeFullySubscribed 
    extend Resque::Plugins::Retry

    @retry_limit = 3
    @retry_delay = 60

    def self.perform
      Pledge.fully_subscribed.each do |pledge|
        pledge.notify_fully_subscribed
      end  
    end
  end

  class PledgesUncompleted
    extend Resque::Plugins::Retry

    @retry_limit = 3
    @retry_delay = 60

    def self.perform
      Pledge.incomplete.destroy_all
    end
  end

  class PledgeScreenshot
    extend Resque::Plugins::Retry
    @queue = :high

    @retry_limit = 3
    @retry_delay = 60

    def self.perform(pledge_id, url)
      Pledge.find(pledge_id).update_screenshot(url)
    end
  end

end