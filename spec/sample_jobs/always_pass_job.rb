# frozen_string_literal: true

class AlwaysPassJob < ApplicationJob
  def perform(_params)
    1
  end
end
