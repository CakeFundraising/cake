module ResqueSchedule

  class TranferPayments
    extend Resque::Plugins::Retry

    @retry_limit = 3
    @retry_delay = 60

    def self.perform
      Payment.charged.each do |payment|
        payment.transfer!
      end 
    end
  end
  
end