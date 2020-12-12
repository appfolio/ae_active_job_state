# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  include AeActiveJobState::HasJobState
end

class AlwaysPassJob < ApplicationJob
  def perform(_params)
    1
  end
end

class AlwaysFailJob < ApplicationJob
  def perform(_params)
    raise StandardError, 'some_error'
  end
end

class HasProgressJob < ApplicationJob
  def perform(_params)
    set_job_progress!('percent' => 20)
  end
end

class HasResultJob < ApplicationJob
  def perform(_params)
    set_job_result!('value' => 20)
  end
end
