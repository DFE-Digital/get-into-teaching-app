class EventsController < ApplicationController
  before_action :load_events, only: %i[index search]
  
  MAXIMUM_EVENTS_IN_CATEGORY = 1_000

  def index
    @page_title = "Find an event near you"
  end

  def search
    @page_title = "Find an event near you"
    render "index"
  end

  def show
    @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
    @page_title = @event.name
  rescue GetIntoTeachingApiClient::ApiError
    render template: "errors/not_found", status: :not_found
  end

  def show_category
    @type = GetIntoTeachingApiClient::TypesApi.new.get_teaching_event_types.find do |type|
      I18n.t("event_types.#{type.id}.name.plural").parameterize == params[:category]
    end

    render(template: "errors/not_found", status: :not_found) && return if @type.nil?

    api = GetIntoTeachingApiClient::TeachingEventsApi.new
    events_by_type = api.search_teaching_events_indexed_by_type(
      type_id: @type.id, 
      quantity_per_type: MAXIMUM_EVENTS_IN_CATEGORY
    )
    @events = events_by_type[@type.id.to_sym]
  end

private

  def load_events
    @event_search = Events::Search.new(event_search_params)
    @events_by_type = @event_search.query_events
    @group_presenter = Events::GroupPresenter.new(@events_by_type)
  end

  def event_search_params
    defaults = ActionController::Parameters.new(month: Time.zone.today.to_formatted_s(:yearmonth))

    (params[Events::Search.model_name.param_key] || defaults)
      .permit(:type, :distance, :postcode, :month)
  end
end
