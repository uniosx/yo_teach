ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)

require 'simplecov'
SimpleCov.start 'rails'

require 'rspec/rails'
require 'rspec/autorun'
require "capybara/rspec"
require 'factory_girl_rails'
require 'capybara/poltergeist'
require 'sucker_punch/testing/inline'

Capybara.javascript_driver = :poltergeist
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include Capybara::DSL
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    ActionMailer::Base.deliveries = []
  end

  config.before(:each, job: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

