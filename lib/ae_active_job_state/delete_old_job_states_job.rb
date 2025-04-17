# frozen_string_literal: true

module AeActiveJobState
  class DeleteOldJobStatesJob < ActiveJob::Base
    def perform(older_than_days: 30)
      JobState.where(updated_at: ...older_than_days.days.ago).destroy_all
    end
  end
end
