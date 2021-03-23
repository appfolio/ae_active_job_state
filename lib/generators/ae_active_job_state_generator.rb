# frozen_string_literal: true

require 'rails/generators/active_record/migration'

class AeActiveJobStateGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration

  source_root File.expand_path('./ae_active_job_state/templates', __dir__)
  class_option :since_version, default: '0.0.0'

  MIGRATIONS = [
    %w[0.1.0 create_ae_active_job_state_tables.rb],
    %w[0.3.0 add_worker_class_column_to_job_state_table.rb]
  ].freeze

  def copy_migrations
    since_version = Gem::Version.new(options['since_version'])
    MIGRATIONS.each do |version, file|
      migration_template file, "db/migrate/#{file}" if Gem::Version.new(version) > since_version
    end
  end
end
