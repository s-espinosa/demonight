ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!
OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
  provider: 'github',
  uid: '123456',
  info: {
    name: "First Last",
    email: "first@last.com",
    nickname: "nick",
    urls: {
      GitHub: "https://github.com/nick"
    }
  }
})

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    desired_capabilities: capabilities
end

Capybara.javascript_driver = :headless_chrome

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.before(:suite) do
      if config.use_transactional_fixtures?
        raise(<<-MSG)
          Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
          (or set it to false) to prevent uncommitted transactions being used in
          JavaScript-dependent specs.

          During testing, the app-under-test that the browser driver connects to
          uses a different database connection to the database connection used by
          the spec. The app's database connection would not be able to access
          uncommitted transaction data setup over the spec's database connection.
        MSG
      end
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.strategy = :transaction
    end

    config.before(:each, type: :feature) do
      driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

      if !driver_shares_db_connection_with_specs
        DatabaseCleaner.strategy = :truncation
      end
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.append_after(:each) do
      DatabaseCleaner.clean
    end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
