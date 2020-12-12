# frozen_string_literal: true

require_relative 'lib/ae_active_job_state/version'

Gem::Specification.new do |spec|
  spec.name          = 'ae_active_job_state'
  spec.version       = AeActiveJobState::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.author        = 'AppFolio'
  spec.email         = 'opensource@appfolio.com'
  spec.description   = 'Store ActiveJob status in ActiveRecord'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/appfolio/ae_active_job_state'
  spec.license       = 'MIT'
  spec.files         = Dir['**/*'].select { |f| f[%r{^(lib/|LICENSE.txt|.*gemspec)}] }
  spec.require_paths = ['lib']

  spec.add_dependency 'aasm', '~> 5.1'
  spec.add_dependency 'activejob', '>= 6', '< 7'
  spec.add_dependency 'activerecord', '>= 6', '< 7'
  spec.add_dependency 'activesupport', '>= 6', '< 7'
end
