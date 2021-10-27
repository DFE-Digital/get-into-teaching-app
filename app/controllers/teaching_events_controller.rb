class TeachingEventsController < ApplicationController
  include CircuitBreaker

  layout "teaching_events"

  def index
  end
end
