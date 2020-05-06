require 'simplecov'
SimpleCov.start

require "bundler/setup"
require "dotenv/load"
require "pwinty"
require "vcr"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcrs"
  c.hook_into :webmock
  c.filter_sensitive_data('<API_KEY>') { Pwinty::API_KEY }
  c.filter_sensitive_data('<MERCHANT_ID>') { Pwinty::MERCHANT_ID }
end
