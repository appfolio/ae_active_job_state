# frozen_string_literal: true

case RUBY_VERSION
when '2.6.3'
  appraise "ruby-#{RUBY_VERSION}-rails60" do
    gem 'activerecord', '~> 6.0.0'
    gem 'activesupport', '~> 6.0.0'
    gem 'activejob', '~> 6.0.0'
  end

  appraise "ruby-#{RUBY_VERSION}-rails61" do
    gem 'activerecord', '~> 6.1.0'
    gem 'activesupport', '~> 6.1.0'
    gem 'activejob', '~> 6.1.0'
  end
when '2.7.1'
  appraise "ruby-#{RUBY_VERSION}-rails60" do
    gem 'activerecord', '~> 6.0.0'
    gem 'activesupport', '~> 6.0.0'
    gem 'activejob', '~> 6.0.0'
  end

  appraise "ruby-#{RUBY_VERSION}-rails61" do
    gem 'activerecord', '~> 6.1.0'
    gem 'activesupport', '~> 6.1.0'
    gem 'activejob', '~> 6.1.0'
  end
else
  raise "Unsupported Ruby version #{RUBY_VERSION}"
end
