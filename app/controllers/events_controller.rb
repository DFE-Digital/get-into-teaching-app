class EventsController < ApplicationController
  def index
    @events = GetIntoTeachingApi::Client.upcoming_events
  end

  def search
    @event_search = Events::Search.new(event_search_params)
    @events = @event_search.query_events

    render :index
  end

private

  def event_search_params
    params.permit(:type, :distance, :postcode, :month)
  end
end
