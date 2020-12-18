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
