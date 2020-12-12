# frozen_string_literal: true

require 'spec_helper'

describe AeActiveJobState::JobState, type: %i[model] do
  describe 'presence validations' do
    must_have_attributes = %i[status active_job_id]
    must_have_attributes.each do |attribute|
      it { is_expected.to validate_presence_of(attribute) }
    end
  end
end
