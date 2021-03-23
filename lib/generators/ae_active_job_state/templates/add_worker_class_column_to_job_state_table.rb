# frozen_string_literal: true

class AddWorkerClassColumnToJobStateTable < ActiveRecord::Migration[6.0]
  def change
    change_table :ae_active_job_state_job_states do |t|
      t.string :worker_class
    end
  end
end
