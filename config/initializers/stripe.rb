Stripe.api_key = ENV['STRIPE_API_KEY']

StripeEvent.subscribe 'charge.succeeded' do |event|
  DonationNotification.charge_succeeded(event.data.object).deliver
end