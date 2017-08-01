require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../dummy/config/environment', __FILE__)

require 'rspec/rails'
require 'factory_girl'
require 'ffaker'
require 'rspec/active_model/mocks'
require 'shoulda-matchers'
require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/capybara_ext'
require 'spree_events_tracker/factories'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # config.filter_run focus: true
  config.infer_spec_type_from_file_location!
  config.raise_errors_for_deprecations!
  config.use_transactional_fixtures = false

  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::ControllerRequests, type: :controller

  # config.include(Shoulda::Matchers::ActiveModel, type: :model)
  # config.include(Shoulda::Matchers::ActiveRecord, type: :model)

  config.mock_with :rspec
  config.color = true

  config.fail_fast = ENV['FAIL_FAST'] || false

  config.mock_with :rspec do |mock|
    mock.syntax = [:should, :expect]
  end
end
