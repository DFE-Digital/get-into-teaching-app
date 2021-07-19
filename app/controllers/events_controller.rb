class EventsController < ApplicationController
  include CircuitBreaker

  before_action :load_event_search, only: %i[search index]
  before_action :search_events, only: %i[search]
  before_action :load_upcoming_events, only: %i[index]
  layout "application"

  UPCOMING_EVENTS_PER_TYPE = 3
  MAXIMUM_EVENTS_PER_CATEGORY = 1_000

  def index
    @page_title = "Find an event near you"
    @front_matter = {
      "description" => "Get your questions answered at an event.",
      "title" => "Find an event near you",
      "image" => "media/images/content/hero-images/0002.jpg",
    }

    render layout: "events"
  end

  def search
    @page_title = "Find an event near you"
    @front_matter = { "description" => "Get your questions answered at an event." }

    render "index", layout: "events"
  end

  def show
    breadcrumb "events.search", :events_path

    @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
    render_not_found && return if @event.status_id == pending_event_status_id

    @page_title = @event.name
    @front_matter = { "description" => @event.summary }

    category_name = t("event_types.#{@event.type_id}.name.plural")
    breadcrumb category_name, event_category_path(category_name.parameterize)
  rescue GetIntoTeachingApiClient::ApiError => e
    raise if e.code != 404

    render_not_found
  end

  def not_available
    render "not_available"
  end

protected

  def not_available_path
    events_not_available_path
  end

private

  def render_not_found
    @fullwidth = true
    render "not_found"
  end

  def load_upcoming_events
    api = GetIntoTeachingApiClient::TeachingEventsApi.new
    search_results = api.search_teaching_events_grouped_by_type(
      quantity_per_type: UPCOMING_EVENTS_PER_TYPE,
      start_after: DateTime.now.utc.beginning_of_day,
    )
    @group_presenter = Events::GroupPresenter.new(search_results)
    @events_by_type = @group_presenter.sorted_events_by_type
    @no_results = @events_by_type.all? { |_, events| events.empty? }
  end

  def search_events
    search_results = @event_search.query_events(MAXIMUM_EVENTS_PER_CATEGORY)

    @display_empty_types = @event_search.type.nil?
    @performed_search = true
    @events_search_type = params.dig("events_search", "type")

    @group_presenter = Events::GroupPresenter.new(search_results, @display_empty_types)
    pages = params.permit(@group_presenter.page_param_names.values)
    @events_by_type = @group_presenter.paginated_events_by_type(pages)
    @no_results = @events_by_type.all? { |_, events| events.empty? }
  end

  def load_event_search
    @event_search = Events::Search.new(event_search_params)
  end

  def event_search_params
    defaults = ActionController::Parameters.new(month: Time.zone.today.to_formatted_s(:yearmonth))

    (params[Events::Search.model_name.param_key] || defaults)
      .permit(:type, :distance, :postcode, :month)
  end

  def pending_event_status_id
    GetIntoTeachingApiClient::Constants::EVENT_STATUS["Pending"]
  end
end
