require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "vcr"

VCR.configure do |config|
  config.ignore_request do |request|
    request.uri == "http://127.0.0.1:9515/shutdown"
    request.uri == "http://127.0.0.1:9516/shutdown"
  end

  config.cassette_library_dir = "vcr/vcr_cassettes"
  config.hook_into :webmock
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
