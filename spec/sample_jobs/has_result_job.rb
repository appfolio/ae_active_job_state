# frozen_string_literal: true

class HasResultJob < ApplicationJob
  def perform(_params)
    set_job_result!('value' => 20)
  end
end
