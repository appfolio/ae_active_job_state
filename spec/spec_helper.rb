# frozen_string_literal: true

require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

if ENV['WITH_COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start do
    enable_coverage :branch
    add_filter %r{\A/spec}
  end
end

require 'ae_active_job_state'

RSpec.configure do |config|
  config.mock_with :mocha
end
