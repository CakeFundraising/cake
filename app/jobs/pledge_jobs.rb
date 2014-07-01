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

end