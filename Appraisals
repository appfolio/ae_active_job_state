# frozen_string_literal: true

unless Gem::Requirement.new(['>= 3.3', '< 4.1']).satisfied_by?(Gem::Version.new(RUBY_VERSION))
  raise "Unsupported Ruby version #{RUBY_VERSION}"
end

appraise "ruby-#{RUBY_VERSION}_rails72" do
  source 'https://appfolio.jfrog.io/artifactory/api/gems/appfolio-ae_active_job_state-gem/' do
    gem 'rails', '~> 7.2.0'
  end
end

appraise "ruby-#{RUBY_VERSION}_rails80" do
  source 'https://appfolio.jfrog.io/artifactory/api/gems/appfolio-ae_active_job_state-gem/' do
    gem 'rails', '~> 8.0.0'
  end
end

appraise "ruby-#{RUBY_VERSION}_rails81" do
  source 'https://appfolio.jfrog.io/artifactory/api/gems/appfolio-ae_active_job_state-gem/' do
    gem 'rails', '~> 8.1.0'
  end
end
