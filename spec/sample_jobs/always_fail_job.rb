# frozen_string_literal: true

class AlwaysFailJob < ApplicationJob
  def perform(_params)
    raise StandardError, 'some_error'
  end
end
