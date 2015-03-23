# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'rails_helper'
require File.expand_path("../../config/environment", __FILE__)
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}
require 'rspec/rails'
require 'shoulda/matchers'
require 'capybara/rspec'
require 'simplecov'
require 'cancan/matchers'
require 'money-rails/test_helpers'
require 'sunspot_test/rspec'
require 'shoulda/matchers'

SimpleCov.start 'rails'

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

#Use sqlite
setup_sqlite_db = lambda do
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

  #load "#{Rails.root.to_s}/db/schema.rb" # use db agnostic schema by default
  ActiveRecord::Migrator.up('db/migrate') # use migrations
end
silence_stream(STDOUT, &setup_sqlite_db)

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!


  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros, type: :controller
  config.include UserMacros
  config.include FactoryHelpers
  config.include FactoryGirl::Syntax::Methods
  config.include MoneyRails::TestHelpers

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end
  
  config.before(:each) do
    DatabaseCleaner.clean_with :transaction
  end
  
  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end
  
  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
