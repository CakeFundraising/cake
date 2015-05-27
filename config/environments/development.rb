Cake::Application.configure do
  require 'pusher'

  Pusher.app_id = ENV['PUSHER_APP_ID']
  Pusher.key    = ENV['PUSHER_APP_KEY']
  Pusher.secret = ENV['PUSHER_APP_SECRET']

  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  #GA.tracker = "UA-55367562-2"
  #GA.script_source = :doubleclick

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.action_controller.perform_caching = true

  config.stripe.publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  config.stripe.secret_key = ENV['STRIPE_SECRET_KEY']

  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.mandrillapp.com',
    port:                 587,
    enable_starttls_auto: true,
    user_name:            ENV['MANDRILL_USERNAME'],
    password:             ENV['MANDRILL_PASSWORD'],
    authentication:       'plain'
  }
end
