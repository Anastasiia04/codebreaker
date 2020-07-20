require 'simplecov'
SimpleCov.start do
  minimum_coverage 95
  add_filter './lib/'
end
require 'psych'
require 'rspec'
require 'bundler/setup'
require_relative '../lib/codebreaker.rb'
require_relative '../lib/validate.rb'
require_relative '../lib/user.rb'
require_relative '../lib/difficulty.rb'
require_relative '../lib/errors/attempt_error.rb'
require_relative '../lib/errors/choose_error.rb'
require_relative '../lib/errors/length_error.rb'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
