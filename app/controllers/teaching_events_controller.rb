class TeachingEventsController < ApplicationController
  include CircuitBreaker

  before_action :setup_filter, only: :index

  FEATURED_EVENT_COUNT = 2 # 2 featured events max on the first page
  EVENT_COUNT = 15 # 15 regular ones per page

  FEATURED_EVENT_TYPES = GetIntoTeachingApiClient::Constants::EVENT_TYPES.values_at(
    "Train to Teach event",
    "Question Time",
  ).freeze

  def index
    @page_title = "Find an event near you"

    setup_results

    if @event_search.valid?
      all_events = @event_search.results.sort_by(&:start_at)

      # featured events will go in a special grey box
      @featured_events = all_events.select { |e| e.type_id.in?(FEATURED_EVENT_TYPES) }.first(FEATURED_EVENT_COUNT)
      @events = Kaminari.paginate_array(all_events - @featured_events).page(params[:page]).per(EVENT_COUNT)
    else
      @featured_events = []
      @events = []

      render :index
    end
  end

  def show
    breadcrumb "Teaching events", "/teaching-events"

    @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
    @page_title = @event.name

    render layout: "teaching_event"
  end

  def about_ttt_events
    breadcrumb "Teaching events", "/teaching-events"
  end

private

  def search_params
    params.permit(teaching_events_search: [:postcode, :distance, { online: [], type: [] }])[:teaching_events_search]
  end

  def setup_filter
    @distances = TeachingEvents::Search::DISTANCES
  end

  def setup_results
    @event_search = TeachingEvents::Search.new(search_params)
  end
end
