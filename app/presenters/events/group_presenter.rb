module Events
  class GroupPresenter
    attr_accessor :events_by_type, :display_empty_types
    alias_method :display_empty_types?, :display_empty_types

    def initialize(events_by_type, display_empty_types = false)
      @display_empty_types = display_empty_types
      @events_by_type = events_by_type
        .transform_keys { |k| k.to_s.to_i }
        .transform_values { |v| v.sort_by { |e| [event_type_name(e.type_id), e.start_at] } }
    end

    def get_into_teaching_events
      empty_types = get_into_teaching_type_ids.product([[]]).to_h
      @get_into_teaching_events ||= empty_types.merge!(events_by_type.slice(*get_into_teaching_type_ids))
    end

    def school_and_university_events
      empty_types = { school_and_university_type_id => [] }
      @school_and_university_events ||= empty_types.merge!(events_by_type.slice(school_and_university_type_id))
    end

    def display_get_into_teaching_events?
      get_into_teaching_events.values.flatten.any? || @display_empty_types
    end

    def display_school_and_university_events?
      school_and_university_events.values.flatten.any? || @display_empty_types
    end

  private

    def event_type_name(type_id)
      GetIntoTeachingApiClient::Constants::EVENT_TYPES.values.index(type_id)
    end

    def get_into_teaching_type_ids
      @get_into_teaching_type_ids ||= GetIntoTeachingApiClient::Constants::GET_INTO_TEACHING_EVENT_TYPES.values
    end

    def school_and_university_type_id
      GetIntoTeachingApiClient::Constants::EVENT_TYPES["School or University Event"]
    end
  end
end
