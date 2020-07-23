class EventsController < ApplicationController
  def index
    @events = GetIntoTeachingApiClient::TeachingEventsApi.new.get_upcoming_teaching_events
    @event_search = Events::Search.new
    @show_categorised_events = true
  end

  def search
    @event_search = Events::Search.new(event_search_params)
    @events = @event_search.query_events

    render "index"
  end

  def show
    @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
  rescue GetIntoTeachingApiClient::ApiError
    render template: "errors/not_found", status: :not_found
  end

private

  def event_search_params
    params
      .require(Events::Search.model_name.param_key)
      .permit(:type, :distance, :postcode, :month)
  end
end
