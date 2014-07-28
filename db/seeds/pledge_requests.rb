@pledge_requests = @campaigns.flat_map do |c|
  create(4, c.pledge_requests) do |pr|
    pr.fundraiser = c.fundraiser
    pr.sponsor = @sponsors.sample
  end
end  

puts "#{@pledge_requests.count} Pledge Requests created."