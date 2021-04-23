# frozen_string_literal: true

module AeActiveJobState
  module HasJobState
    extend ActiveSupport::Concern

    included do
      attr_accessor :job_state

      delegate :id, :progress, :result, to: :job_state

      # before_enqueue is only triggered on `perform_later`
      # `perform_now` would go directly to around_perform
      before_enqueue do |job|
        @job_state = AeActiveJobState::JobState.create!(status: 'pending', active_job_id: job.job_id,
                                                        args: job.arguments, worker_class: job.class)
      end

      around_perform do |job, block|
        # This is effectively the same logic as #create_or_find_by!, the main difference is we also fail on
        # RecordInvalid. This allows us to have additional uniqueness validations in the model and still fall back to
        # the find_by.
        #
        # We do this here to prevent a race condition if the job is processed before the initial job state is created.
        # This can occur in the case that the job is enqueued in a transaction and a worker picks up the work before the
        # transaction commits. In this case, this create will now wait on the insertion intention lock on the
        # active_job_id index created by the insert in before_enqueue, throw a record not unique, then find the correct
        # state model.
        #
        # We continue to handle the case where the state was fully inserted before this callback is hit and the case
        # where the job was never enqueued.
        begin
          @job_state = AeActiveJobState::JobState.create!(status: 'pending', active_job_id: job.job_id,
                                                          args: job.arguments, worker_class: job.class)
        rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
          @job_state = AeActiveJobState::JobState.find_by!(active_job_id: job.job_id)
        end

        job_state.running!
        job_state.reload
        block.call
        job_state.finished!
      rescue StandardError => e
        @job_state.failed!
        raise e
      end
    end

    def set_job_progress!(progress)
      job_state.update!(progress: progress)
    end

    def set_job_result!(result)
      job_state.update!(result: result)
    end
  end
end
