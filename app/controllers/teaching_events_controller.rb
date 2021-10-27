class TeachingEventsController < ApplicationController
  include CircuitBreaker

  layout "teaching_events"

  def index
    @page_title = "Find an event near you"
    @event_search = TeachingEvents::Search.new(search_params)
  end

private

  def search_params
    params.permit(teaching_events_search: %i[postcode setting type])[:teaching_events_search]
  end
end
