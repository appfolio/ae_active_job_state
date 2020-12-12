# frozen_string_literal: true

module AeActiveJobState
  class JobState < ActiveRecord::Base
    self.table_name = 'ae_active_job_state_job_states'

    validates :status, presence: true
    validates :active_job_id, presence: true
  end
end
