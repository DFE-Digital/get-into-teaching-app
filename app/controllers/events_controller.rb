class EventsController < ApplicationController
  def index
    @events = GetIntoTeachingApi::Client.upcoming_events
  end
end
