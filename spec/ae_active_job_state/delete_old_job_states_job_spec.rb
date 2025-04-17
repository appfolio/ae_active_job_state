# frozen_string_literal: true

require 'spec_helper'

describe AeActiveJobState::DeleteOldJobStatesJob do
  it 'delete only old job states' do
    js1 = AeActiveJobState::JobState.create!(
      status: AeActiveJobState::JobState::STATE_PENDING,
      updated_at: Time.now - 5.days,
      active_job_id: 'aj1'
    )
    js2 = AeActiveJobState::JobState.create!(
      status: AeActiveJobState::JobState::STATE_PENDING,
      updated_at: Time.now - 20.days,
      active_job_id: 'aj2'
    )
    _js3 = AeActiveJobState::JobState.create!(
      status: AeActiveJobState::JobState::STATE_PENDING,
      updated_at: Time.now - 40.days,
      active_job_id: 'aj3'
    )
    described_class.perform_now
    expect(AeActiveJobState::JobState.pluck(:id)).to contain_exactly(js1.id, js2.id)
  end
end
