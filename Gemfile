source 'https://rubygems.org'

ruby '2.0.0'

gem 'rails', '4.0.4'
gem 'turbolinks'

#Assets
gem 'sass-rails', '~> 4.0.2'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'therubyracer', platforms: :ruby

#JS
gem 'rails-timeago'
gem 'chosen-rails'
gem 'bootstrap-datepicker-rails'
gem 'zeroclipboard-rails'

#Views
gem 'slim'
gem 'slim-rails'
gem 'bootstrap-sass', '~> 3.1.1'
gem 'kaminari-bootstrap'
gem 'formtastic-bootstrap'
gem 'cocoon'
gem 'cocoon_limiter'
gem 'draper'

#Storage
gem 'pg'

#Server
gem 'thin', group: :development

#Image processing
gem 'carrierwave'
gem 'rmagick', require: 'RMagick'
gem 'jquery-fileupload-rails'

#Cron & Asynchronous tasks
gem 'whenever', require: false

#CLI
gem 'pry-rails'

group :development do
  gem 'quiet_assets'
end

#Utils
gem 'money-rails'
gem 'carmen-rails'
gem 'email_validator', :require => 'email_validator/strict'

#User registration
gem "devise"

#User permissions
gem 'cancancan'

# Omniauth gems
gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-linkedin-oauth2'

#Admin panel
gem 'activeadmin', github: 'gregbell/active_admin'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem 'database_cleaner'
gem 'faker'

group :test, :development do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'callback_skipper'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'pickle'
  gem 'capybara'
  gem 'webmock'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'shoulda-matchers'
  gem "launchy"
end

group :production do
  gem 'unicorn'
  gem 'unicorn-worker-killer'
  gem 'rails_12factor'
end
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 1.2'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
