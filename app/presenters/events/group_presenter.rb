module Events
  class GroupPresenter
    def initialize(events_by_type, display_empty_types = false)
      @display_empty_types = display_empty_types
      @events_by_type = events_by_type
        .transform_keys { |k| k.to_s.to_i }
        .transform_values { |v| v.sort_by { |e| [event_type_name(e.type_id), e.start_at] } }
    end

    def sorted_events_by_type
      populate_events_by_type.sort_by { |k, _| event_type_ids.index(k) }
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
