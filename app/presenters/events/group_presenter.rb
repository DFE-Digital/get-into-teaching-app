module Events
  class GroupPresenter
    attr_accessor :all_events

    INDEX_PAGE_CAP = 9

    def initialize(events, cap: false)
      @all_events = events.sort_by { |e| [event_type_name(e.type_id), e.start_at] }
      @cap        = cap
    end

    def get_into_teaching_events
      group_by_type_id(all_events.select { |event| event.type_id.in?(get_into_teaching_type_ids) })
    end

    def school_and_university_events
      group_by_type_id(all_events.reject { |event| event.type_id.in?(get_into_teaching_type_ids) })
    end

  private

    def event_type_name(type_id)
      GetIntoTeachingApiClient::Constants::EVENT_TYPES.values.index(type_id)
    end

    def group_by_type_id(events)
      groups = events.group_by(&:type_id)

      return groups unless @cap

      groups.each.with_object({}) do |(type_id, events_in_group), capped_groups|
        capped_groups[type_id] = events_in_group.first(INDEX_PAGE_CAP)
      end
    end

    def get_into_teaching_type_ids
      @get_into_teaching_type_ids ||= GetIntoTeachingApiClient::Constants::GET_INTO_TEACHING_EVENT_TYPES.values
    end
  end
end
