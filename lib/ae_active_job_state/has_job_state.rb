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
                                                        args: job.arguments)
      end

      around_perform do |job, block|
        @job_state = AeActiveJobState::JobState.find_by(active_job_id: job.job_id) ||
                     AeActiveJobState::JobState.create!(status: 'pending', active_job_id: job.job_id,
                                                        args: job.arguments)
        job_state.run!
        job_state.reload
        block.call
        job_state.finish!
      rescue StandardError => e
        @job_state.fail!
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
