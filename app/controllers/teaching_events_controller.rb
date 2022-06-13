class TeachingEventsController < ApplicationController
  class EventNotViewableError < StandardError; end

  include CircuitBreaker

  before_action :setup_filter, only: :index
  before_action :set_front_matter

  rescue_from EventNotViewableError, with: :render_gone

  FEATURED_EVENT_COUNT = 2 # 2 featured events max on the first page
  EVENT_COUNT = 15 # 15 regular ones per page

  FEATURED_EVENT_TYPES = EventType.lookup_by_names(
    "Train to Teach event",
    "Question Time",
  ).freeze

  def create
    encrypted_params = TeachingEvents::Search.new(search_params).encrypted_attributes
    redirect_to teaching_events_path({ teaching_events_search: encrypted_params })
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

    breadcrumb "Get into Teaching events", "/teaching-events"
    breadcrumb @event.name, request.path

    @page_title = @event.name

    render layout: "teaching_event"
  end

  def about_ttt_events
    breadcrumb "Get into Teaching events", "/teaching-events"
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

      raise ActionController::RoutingError, "Not Found" if status.pending?
      raise(EventNotViewableError) unless status.viewable?
    end
  end

  def static_page_actions
    %i[about_ttt_events]
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

  def set_front_matter
    @front_matter = { "noindex" => true }
  end

  def render_gone
    render("gone", status: :gone, layout: "content")
  end
end
