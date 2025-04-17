# frozen_string_literal: true

class AddWorkerClassColumnToJobStateTable < ActiveRecord::Migration["#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}"]
  def change
    change_table :ae_active_job_state_job_states do |t|
      t.string :worker_class
    end
  end
end
