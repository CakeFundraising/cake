source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails', '4.2.0'
gem 'turbolinks', '~> 2.5.3'
#gem 'jquery-turbolinks'
gem 'meta-tags', :require => 'meta_tags'
gem 'metamagic'

#Analytics
#gem 'google-analytics-rails'

#Assets
gem 'sass-rails', '~> 5.0.1'
gem 'uglifier', '~> 2.6.1'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails', '~> 4.0.3'
gem 'therubyracer', platforms: :ruby
gem 'modernizr-rails', '~> 2.7.1'

#JS
gem 'rails-timeago'
gem 'chosen-rails'
gem 'bootstrap-datepicker-rails', '~> 1.3.0.2'
gem 'zeroclipboard-rails', '~> 0.1.0'

#Views
gem 'slim'
gem 'slim-rails'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'kaminari'
gem 'bootstrap-kaminari-views'
gem 'formtastic-bootstrap', '~> 3.1.0'
gem 'bootstrap-switch-rails'
gem 'cocoon'
gem 'cocoon_limiter'
gem 'draper'

#Storage
gem 'pg'
gem 'sqlite3'

#Solr
gem 'sunspot_rails'
gem 'sunspot_solr'

#Servers
gem 'redis-rails'
gem 'thin', group: :development

#Image processing
gem 'jcrop-rails-v2'
gem 'cloudinary'

#Cron & Asynchronous tasks
gem 'resque', '~> 1.25.2', require: 'resque/server'
gem 'resque-retry'
gem 'resque_mailer'

#CLI
gem 'pry-rails'

group :development do
  gem 'quiet_assets'
end

#Utils
gem 'money-rails', '~> 1.3.0'
gem 'carmen-rails'
gem 'email_validator', :require => 'email_validator/strict'
gem 'shareable'
gem 'american_date'
gem "jquery-validation-rails"
gem 'high_voltage'
gem 'roadie-rails'
gem 'prawn'
gem 'secure_headers'
gem 'counter_culture'
gem 'mail_form'

#Browser Fingerprinting
gem 'fingerprintjs-rails'

#App performance
gem 'newrelic_rpm'

#Real Time
gem 'pusher'

#User registration
gem "devise"

#User permissions
gem 'cancancan'

# Omniauth gems
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-linkedin-oauth2'
gem 'omniauth-stripe-connect'

#Admin panel
gem 'activeadmin', github: 'activeadmin'
gem 'inherited_resources', github: 'josevalim/inherited_resources', branch: 'rails-4-2'

#Payments
gem 'stripe-rails'
gem 'stripe_event'

group :doc do
  gem 'sdoc', require: false
end

gem 'database_cleaner'
gem 'faker'

group :development do
  gem 'meta_request'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'callback_skipper'
  gem 'byebug'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'sunspot_test'
  gem 'pickle'
  gem 'capybara'
  gem 'webmock'
  gem 'selenium-webdriver', '~> 2.43.0'
  gem 'simplecov', require: false
  gem 'shoulda-matchers'
  gem "launchy"
end

group :production do
  gem 'unicorn'
  gem 'unicorn-worker-killer'
  gem 'rails_12factor'
end