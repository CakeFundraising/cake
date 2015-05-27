StripeEvent.subscribe 'charge.succeeded' do |event|
  DonationNotification.charge_succeeded(event.data.object).deliver
end