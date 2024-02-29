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

  spec.required_ruby_version = Gem::Requirement.new('< 3.4')
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.add_dependency('aasm', ['>= 5.1', '< 6'])
  spec.add_dependency('activejob', ['>= 6.1', '< 7.2'])
  spec.add_dependency('activerecord', ['>= 6.1', '< 7.2'])
  spec.add_dependency('activesupport', ['>= 6.1', '< 7.2'])
end
