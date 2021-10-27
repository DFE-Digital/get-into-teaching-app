class TeachingEventsController < ApplicationController
  include CircuitBreaker

  layout "teaching_events"

  def index
    @page_title = "Find an event near you"
    @event_search = TeachingEvents::Search.new(search_params)
    @events = @event_search.results
  end

private

  def search_params
    params.permit(teaching_events_search: [:postcode, { online: [], type: [] }])[:teaching_events_search]
  end
end
