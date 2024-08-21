class TeachingEventsController < ApplicationController
  class EventNotViewableError < StandardError; end

  include CircuitBreaker

  before_action :setup_filter, only: :index

  rescue_from EventNotViewableError, with: :render_gone

  FEATURED_EVENT_COUNT = 2 # 2 featured events max on the first page
  EVENT_COUNT = 15 # 15 regular ones per page

  FEATURED_EVENT_TYPES = Crm::EventType.lookup_by_names(
    "Get Into Teaching event",
  ).freeze

  def create
    encrypted_params = TeachingEvents::Search.new(search_params).encrypted_attributes
    redirect_to events_path({ teaching_events_search: encrypted_params })
  end

  def index
    @front_matter = {
      title: "Find an event near you or online",
      description: "Find out more about getting into teaching at a free event where you can get all your questions answered by teachers, advisers and training providers.",
      breadcrumbs: false
    }.with_indifferent_access

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

    breadcrumb "Events", events_path
    breadcrumb @event.name, request.path

    @front_matter = {
      title: @event.name,
      description: @event.summary,
    }.with_indifferent_access

    render layout: "teaching_event"
  end

  def about_git_events
    @git_events = git_events

    @front_matter = {
      title: "Get Into Teaching events",
      description: "Find out what happens at a Get Into Teaching event and book your place, whether you’re ready to start your career in teaching or just curious.",
    }.with_indifferent_access

    render layout: "minimal"
  end

  def not_available
    render "not_available"
  end

  def git_statistics
    open_git_events = git_events.select { |e| e.status_id == Crm::EventStatus.open_id }

    statistics = {
      open_events_count: open_git_events.count,
    }

    respond_to do |format|
      format.json { render json: statistics }
    end
  end

private

  def git_events
    @git_events ||= TeachingEvents::Search.new(type: %w[git]).results
  end

  def not_available_path
    events_not_available_path
  end

  def retrieve_event
    GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id]).tap do |event|
      status = Crm::EventStatus.new(event)

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
    @national_git_events = git_events.select(&:is_online) if @event_search.valid? && @event_search.results.empty?
  end

  def render_gone
    render("gone", status: :gone, layout: "content")
  end
end
