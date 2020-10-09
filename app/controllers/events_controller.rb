class EventsController < ApplicationController
  before_action :load_events, only: %i[index search]

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
    @events = api.search_teaching_events(type_id: @type.id)
  end

private

  def load_events
    @event_search = Events::Search.new(event_search_params)
    @events = @event_search.query_events
    @group_presenter = Events::GroupPresenter.new(@events, cap: cap_results?)
  end

  def event_search_params
    defaults = ActionController::Parameters.new(month: Time.zone.today.to_formatted_s(:yearmonth))

    (params[Events::Search.model_name.param_key] || defaults)
      .permit(:type, :distance, :postcode, :month)
  end

  # When there's a value in the 'distance', 'type' or 'postcode' events_search param, an actual
  # search has been made so display all results. If none have values it's either the index page
  # or an open-ended search ('All Events'/'Nationwide') so apply a cap so the user isn't swamped
  # with events
  def cap_results?
    active_search_params = params
      .fetch("events_search", {})
      .reject { |_, v| v.blank? }

    %i[distance type postcode].none? { |param| active_search_params.key?(param) }
  end
end
