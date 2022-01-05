module SpecHelpers
  module Events
    def group_events_by_type(events)
      events.group_by(&:type_id).map do |type_id, events_of_type|
        GetIntoTeachingApiClient::TeachingEventsByType.new(type_id: type_id, teaching_events: events_of_type)
      end
    end
  end
end
