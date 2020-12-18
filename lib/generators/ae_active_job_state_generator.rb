# frozen_string_literal: true

require 'rails/generators/active_record/migration'

class AeActiveJobStateGenerator < Rails::Generators::Base
  include ActiveRecord::Generators::Migration

  source_root File.expand_path('./ae_active_job_state/templates', __dir__)

  def copy_migrations
    migration_template 'create_ae_active_job_state_tables.rb', 'db/migrate/create_ae_active_job_state_tables.rb'
  end
end
