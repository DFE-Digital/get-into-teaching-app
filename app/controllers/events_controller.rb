class EventsController < ApplicationController
  before_action :load_event_search, only: %i[search index]
  before_action :search_events, only: %i[search]
  before_action :load_upcoming_events, only: %i[index]
  layout "application"

  UPCOMING_EVENTS_PER_TYPE = 3

  def index
    @page_title = "Find an event near you"
    render layout: "events"
  end

  def search
    @page_title = "Find an event near you"
    render "index", layout: "events"
  end

  def show
    @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
    @page_title = @event.name
  end

private

  def load_upcoming_events
    api = GetIntoTeachingApiClient::TeachingEventsApi.new
    @events_by_type = api.search_teaching_events_grouped_by_type(
      quantity_per_type: UPCOMING_EVENTS_PER_TYPE,
      start_after: DateTime.now.utc.beginning_of_day,
    )
    @group_presenter = Events::GroupPresenter.new(@events_by_type)
  end

  def search_events
    @events_by_type = @event_search.query_events
    @display_empty_types = @event_search.type.nil?
    @group_presenter = Events::GroupPresenter.new(@events_by_type, @display_empty_types)
    @performed_search = true
  end

  def load_event_search
    @event_search = Events::Search.new(event_search_params)
  end

  def event_search_params
    defaults = ActionController::Parameters.new(month: Time.zone.today.to_formatted_s(:yearmonth))

    (params[Events::Search.model_name.param_key] || defaults)
      .permit(:type, :distance, :postcode, :month)
  end
end
