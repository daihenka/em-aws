# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper.rb"` to ensure that it is only
# loaded once.

require "bundler/setup"
require "em-aws"
require "webmock/rspec" unless ENV['AWS_TEST_MODE'] == 'live'

Dir[File.join File.dirname(__FILE__), 'support', '**', '*.rb'].each {|f| require f}

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run_excluding slow: true unless ENV['AWS_SLOW_TESTS'] == 'true'
  # config.filter_run :focus

  # EM::AWS.loglevel = ::Logger::DEBUG

  # Run in 'mock' or 'live' mode based on the AWS_TEST_MODE variable. (Defaults to 'mock.')
  # If in live mode, the credentials must also be set in the environment.
  if ENV['AWS_TEST_MODE'] == 'live'
    config.filter_run_excluding mock: true
    config.before(:all) do
      EventMachine::AWS.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
      EventMachine::AWS.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    end
  else
    config.filter_run_excluding live: true
    WebMock.disable_net_connect!
    config.before(:each) do
      EventMachine::AWS.aws_access_key_id = 'FAKE_KEY'
      EventMachine::AWS.aws_secret_access_key = 'FAKE_SECRET'
    end
    config.before(:each, mock: true) do
      raise "Enable loading from the YAML!"
    end
  end
  
  config.include EventMachineHelper
end
