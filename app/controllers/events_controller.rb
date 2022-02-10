class EventsController < ApplicationController
  include CircuitBreaker

  before_action :load_event_search, only: %i[search index]
  before_action :search_events, only: %i[search]
  before_action :load_upcoming_events, only: %i[index]
  layout "application"

  UPCOMING_EVENTS_PER_TYPE = 3
  MAXIMUM_EVENTS_PER_CATEGORY = 1_000

  def index
    @page_title = "Teacher training events"
    @front_matter = {
      "description" => "Get your questions answered at an event.",
      "title" => "Teacher training events",
      "image" => "media/images/content/hero-images/0002.jpg",
    }

    render layout: "events"
  end

  def search
    @page_title = "Teacher training events"
    @front_matter = { "description" => "Get your questions answered at an event." }

    render "index", layout: "events"
  end

  def show
    breadcrumb "events.search", :events_path

    @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
    status = EventStatus.new(@event)

    render_not_found && return if status.pending?
    render_gone && return unless status.viewable?

    @page_title = @event.name
    @front_matter = { "description" => @event.summary }

    category_name = t("event_types.#{@event.type_id}.name.plural")
    breadcrumb category_name, event_category_path(category_name.parameterize)
  end

  def not_available
    render "not_available"
  end

protected

  def not_available_path
    events_not_available_path
  end

private

  def render_gone
    render "gone", status: :gone
  end

  def load_upcoming_events
    api = GetIntoTeachingApiClient::TeachingEventsApi.new
    search_results = api.search_teaching_events_grouped_by_type(
      quantity_per_type: UPCOMING_EVENTS_PER_TYPE,
      start_after: Time.zone.now.utc.beginning_of_day,
    )
    @group_presenter = Events::GroupPresenter.new(
      search_results,
      display_empty: false,
      ascending: true,
      limit_per_type: UPCOMING_EVENTS_PER_TYPE,
    )
    @events_by_type = @group_presenter.sorted_events_by_type
    @no_results = @events_by_type.all? { |_, events| events.empty? }
  end

  def search_events
    search_results = @event_search.query_events(MAXIMUM_EVENTS_PER_CATEGORY)

    @display_empty_types = @event_search.type.nil?
    @performed_search = true
    @events_search_type = params.dig("events_search", "type")

    @group_presenter = Events::GroupPresenter.new(search_results, display_empty: @display_empty_types)
    pages = params.permit(@group_presenter.page_param_names.values)
    @events_by_type = @group_presenter.paginated_events_by_type(pages)
    @no_results = @events_by_type.all? { |_, events| events.empty? }
  end

  def load_event_search
    @event_search = Events::Search.new(event_search_params)
  end

  def event_search_params
    defaults = ActionController::Parameters.new

    (params[Events::Search.model_name.param_key] || defaults)
      .permit(:type, :distance, :postcode, :month)
  end
end
