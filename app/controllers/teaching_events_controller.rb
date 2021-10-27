class TeachingEventsController < ApplicationController
  include CircuitBreaker

  layout "teaching_events"

  before_action :setup_filter, only: :index

  def index
    @page_title = "Find an event near you"
    @event_search = TeachingEvents::Search.new(search_params)
    @events = @event_search.results
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
end
