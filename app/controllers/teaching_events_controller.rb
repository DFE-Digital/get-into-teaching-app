class TeachingEventsController < ApplicationController
  include CircuitBreaker

  layout "teaching_events"

  before_action :setup_filter, :setup_results, only: :index

  FEATURED_EVENT_COUNT = 2
  FEATURED_EVENT_TYPES = [
    222_750_001, # Train to teach
    222_750_007, # Question time
  ].freeze

  def index
    @page_title = "Find an event near you"
  end

  def show
    @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
    @page_title = @event.name
  end

private

  def search_params
    params.permit(teaching_events_search: [:postcode, :distance, { online: [], type: [] }])[:teaching_events_search]
  end

  def setup_filter
    @distances = [
      OpenStruct.new(value: nil, key: "Nationwide"),
      OpenStruct.new(value: 5, key: "5 miles"),
      OpenStruct.new(value: 10, key: "10 miles"),
      OpenStruct.new(value: 25, key: "25 miles"),
    ]
  end

  def setup_results
    @event_search = TeachingEvents::Search.new(search_params)
    all_events = @event_search.results.sort_by(&:start_at)

    # featured events will go in a special grey box
    @featured_events = all_events.select { |e| e.type_id.in?(FEATURED_EVENT_TYPES) }.first(FEATURED_EVENT_COUNT)
    @events = all_events - @featured_events
  end
end
