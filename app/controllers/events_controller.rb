class EventsController < ApplicationController
  before_action :load_events, only: %i[index search]

  def index
    # Events are loaded in a before_action
  end

  def search
    render "index"
  end

  def show
    @event = GetIntoTeachingApiClient::TeachingEventsApi.new.get_teaching_event(params[:id])
  rescue GetIntoTeachingApiClient::ApiError
    render template: "errors/not_found", status: :not_found
  end

private

  def load_events
    @event_search = Events::Search.new(event_search_params)
    @events = @event_search.query_events
    @events_by_type = @events.each_with_object(Hash.new { |h, k| h[k] = [] }) do |event, hash|
      hash[event.type_id] << event
    end
  end

  def event_search_params
    defaults = ActionController::Parameters.new(month: Time.zone.today.to_formatted_s(:yearmonth))

    (params[Events::Search.model_name.param_key] || defaults)
      .permit(:type, :distance, :postcode, :month)
  end
end
