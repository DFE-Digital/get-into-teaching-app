class TeachingEventsController < ApplicationController
  class EventNotViewableError < StandardError; end

  include CircuitBreaker

  caches_page :about_ttt_events

  before_action :setup_filter, only: :index

  rescue_from EventNotViewableError, with: :render_gone

  FEATURED_EVENT_COUNT = 2 # 2 featured events max on the first page
  EVENT_COUNT = 15 # 15 regular ones per page

  FEATURED_EVENT_TYPES = EventType.lookup_by_names(
    "Train to Teach event",
  ).freeze

  def create
    encrypted_params = TeachingEvents::Search.new(search_params).encrypted_attributes
    redirect_to events_path({ teaching_events_search: encrypted_params })
  end

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
    @event = TeachingEvents::EventPresenter.new(retrieve_event)

    breadcrumb "Get into Teaching events", events_path
    breadcrumb @event.name, request.path

    @page_title = @event.name

    render layout: "teaching_event"
  end

  def about_ttt_events
    @no_ttt_events = GetIntoTeachingApiClient::TeachingEventsApi.new.search_teaching_events(
      quantity: 1,
      type_ids: [EventType.train_to_teach_event_id],
      start_after: Time.zone.now,
    ).blank?

    breadcrumb "Get into Teaching events", events_path
  end

  def not_available
    render "not_available"
  end

private

  def not_available_path
    events_not_available_path
  end

  def retrieve_event
    GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id]).tap do |event|
      status = EventStatus.new(event)

      raise ActionController::RoutingError, "Not Found" if event.nil? || status.pending?
      raise(EventNotViewableError) unless status.viewable?
    end
  end

  def search_params
    params.permit(teaching_events_search: [:postcode, :distance, { online: [], type: [] }])[:teaching_events_search]
  end

  def setup_filter
    @distances = TeachingEvents::Search::DISTANCES
  end

  def setup_results
    @event_search = TeachingEvents::Search.new_decrypt(search_params)
  end

  def render_gone
    render("gone", status: :gone, layout: "content")
  end
end
