# frozen_string_literal: true

module AeActiveJobState
  class JobState < ActiveRecord::Base
    self.table_name = 'ae_active_job_state_job_states'

    validates :status, presence: true
    validates :active_job_id, presence: true, uniqueness: { case_sensitive: false }

    include AASM
    aasm(column: 'status') do
      state :pending, initial: true
      state :running
      state :finished
      state :failed

      event :running do
        transitions to: :running, after: -> { self.started_at = Time.now }
      end

      event :failed do
        transitions to: :failed, after: -> { self.failed_at = Time.now }
      end

      event :finished do
        transitions to: :finished, after: -> { self.finished_at = Time.now }
      end
    end
  end
end
