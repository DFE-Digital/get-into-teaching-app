module Events
  class GroupPresenter
    def initialize(events_by_type, display_empty_types = false, ascending = true)
      @display_empty_types = display_empty_types
      @events_by_type = events_by_type
        .index_by(&:type_id)
        .transform_values do |v|
          events = v.teaching_events.sort_by { |e| [e.start_at] }
          events.reverse! unless ascending
          events
        end
    end

    def sorted_events_by_type
      populate_events_by_type.sort_by { |k, _| event_type_ids.index(k) }
    end

    def sorted_events_of_type(type_id)
      sorted_events_by_type.first { |v| v.first == type_id }&.last
    end

  private

    def populate_events_by_type
      return @events_by_type unless @display_empty_types

      empty_state = event_type_ids.product([[]]).to_h
      empty_state.merge(@events_by_type)
    end

    def event_type_name(type_id)
      event_type_ids.index(type_id)
    end

    def event_type_ids
      GetIntoTeachingApiClient::Constants::EVENT_TYPES.values
    end
  end
end
