# frozen_string_literal: true

require 'spec_helper'

describe AeActiveJobState::JobState, type: %i[model] do
  describe 'presence validations' do
    must_have_attributes = %i[status active_job_id]
    must_have_attributes.each do |attribute|
      it { is_expected.to validate_presence_of(attribute) }
    end
  end

  describe 'uniqueness validations' do
    subject { described_class.create!(status: 'pending', active_job_id: 'qwerty') }

    it { is_expected.to validate_uniqueness_of(:active_job_id).case_insensitive }
  end

  describe 'state transitions' do
    let(:js) { described_class.create!(status: 'pending', active_job_id: 'qwerty') }

    it 'has no timestamp initially' do
      expect(js.reload).to have_attributes(started_at: nil, failed_at: nil, finished_at: nil)
    end

    it 'sets started_at when it runs' do
      js.running!
      expect(js.reload).to have_attributes(started_at: be_present, failed_at: nil, finished_at: nil, status: 'running')
    end

    it 'sets finished_at when it finishes' do
      js.running!
      js.finished!
      expect(js.reload).to have_attributes(started_at: be_present, failed_at: nil, finished_at: be_present,
                                           status: 'finished')
    end

    it 'sets failed_at when it fails' do
      js.running!
      js.failed!
      expect(js.reload).to have_attributes(started_at: be_present, failed_at: be_present, finished_at: nil,
                                           status: 'failed')
    end
  end
end
