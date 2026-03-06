# frozen_string_literal: true

class HasProgressJob < ApplicationJob
  def perform(_params)
    set_job_progress!('percent' => 20)
  end
end
