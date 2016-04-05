ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'

# require shared examples
Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.include Warden::Test::Helpers
  config.include FactoryGirl::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  # config.include Requests::JsonHelpers, type: :controller

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    Warden.test_mode!
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, type: :controller) do
    request.headers['accept'] = 'application/json'
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Warden.test_reset!
  end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

Capybara.javascript_driver = :webkit