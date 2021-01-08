module Helpers
  module Events
    def group_events_by_type(events)
      events.group_by(&:type_id).map do |type_id, events_of_type|
        GetIntoTeachingApiClient::TeachingEventsByType.new(typeId: type_id, teachingEvents: events_of_type)
      end
    end
  end
end
