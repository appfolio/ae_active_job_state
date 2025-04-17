# frozen_string_literal: true

require 'spec_helper'

describe AeActiveJobState::HasJobState do
  describe 'perform_now' do
    it 'creates job state and mark it failed' do
      expect do
        expect do
          AlwaysFailJob.perform_now(1)
        end.to raise_error(StandardError)
      end.to change(AeActiveJobState::JobState, :count)

      expect(AeActiveJobState::JobState.last).to be_failed
    end

    it 'creates job state and mark it finished' do
      expect do
        AlwaysPassJob.perform_now(1)
      end.to change(AeActiveJobState::JobState, :count)

      expect(AeActiveJobState::JobState.last).to be_finished
    end
  end

  it 'returns a job state object with id after enqueuing' do
    job = nil
    expect do
      job = AlwaysPassJob.perform_later(1)
    end.to change(AeActiveJobState::JobState, :count)
    expect(job.job_state.id).to eq AeActiveJobState::JobState.last.id
    expect(job.job_state).to be_pending
  end

  describe 'perform_later' do
    before { ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true }

    after { ActiveJob::Base.queue_adapter.perform_enqueued_jobs = false }

    it 'creates job state and mark it failed' do
      expect do
        expect do
          AlwaysFailJob.perform_later(1)
        end.to raise_error(StandardError)
      end.to change(AeActiveJobState::JobState, :count)

      expect(AeActiveJobState::JobState.last).to be_failed
    end

    it 'creates job state and mark it finished' do
      expect do
        AlwaysPassJob.perform_later(1)
      end.to change(AeActiveJobState::JobState, :count)

      expect(AeActiveJobState::JobState.last).to be_finished
    end
  end

  describe 'job state creation' do
    it 'set the initial state before a wrapping transaction is complete to avoid race conditions' do
      thread = nil
      ActiveRecord::Base.transaction do
        job = AlwaysPassJob.new
        job.run_callbacks(:enqueue)
        thread = Thread.new do
          job.run_callbacks(:perform)
        end
        # Thread run should mark the thread for execution, but from the documentation does not seem to guarantee handing
        # execution to the thread. So we then sleep this thread until the connections reach 2, which should indicate the
        # thread is blocked on the database call.
        thread.run
        sleep(0.1) until ActiveRecord::Base.connection_pool.connections.count == 2
      end
      expect(thread.value).to be(true)
    end

    it 'do not crash on perform if job state has already been created' do
      job = AlwaysPassJob.new
      job.run_callbacks(:enqueue)
      job.run_callbacks(:perform)
      expect(job.job_state).to be_finished
    end

    it 'adds worker class to the state on enqueue' do
      job = AlwaysPassJob.new
      job.run_callbacks(:enqueue)
      expect(job.job_state.worker_class).to eq(AlwaysPassJob.name)
    end

    it 'adds worker class to the state on perform' do
      job = AlwaysPassJob.new
      job.run_callbacks(:perform)
      expect(job.job_state.worker_class).to eq(AlwaysPassJob.name)
    end
  end

  describe 'set job progress and result' do
    before { ActiveJob::Base.queue_adapter.perform_enqueued_jobs = true }

    after { ActiveJob::Base.queue_adapter.perform_enqueued_jobs = false }

    it 'can set job progress' do
      job = HasProgressJob.perform_later(1)
      expect(job.job_state.reload.progress).to eql({ 'percent' => 20 })
    end

    it 'can set job result' do
      job = HasResultJob.perform_later(1)
      expect(job.job_state.reload.result).to eql({ 'value' => 20 })
    end
  end
end
