# frozen_string_literal: true

class CreateAeActiveJobStateTables < ActiveRecord::Migration[6.0]
  def change
    create_table :ae_active_job_state_job_states do |t|
      t.timestamps null: false

      t.string :status, null: false
      t.json :args
      t.json :result
      t.json :progress

      t.datetime :started_at
      t.datetime :finished_at
      t.datetime :failed_at

      t.string :active_job_id, null: false, index: { unique: true }
    end
  end
end
