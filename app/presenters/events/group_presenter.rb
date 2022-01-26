module Events
  class GroupPresenter
    EVENTS_PER_TYPE = 9

    def initialize(events_by_type, display_empty: false, ascending: true, limit_per_type: nil)
      @display_empty_types = display_empty

      events_by_type = merge_question_time_events(events_by_type)

      @events_by_type = events_by_type
        .index_by(&:type_id)
        .transform_values do |v|
          events = v.teaching_events.sort_by { |e| [e.start_at] }
          events = events.take(limit_per_type) if limit_per_type.present?
          events.reverse! unless ascending
          events
        end
    end

    def paginated_events_by_type(pages, per_page = EVENTS_PER_TYPE)
      sorted_events_by_type.map do |type_id, events|
        paginated_events = Kaminari
          .paginate_array(events, total_count: events.count)
          .page(pages[page_param_name(type_id)])
          .per(per_page)

        [type_id, paginated_events]
      end
    end

    def sorted_events_by_type
      populate_events_by_type.sort_by { |k, _| event_type_ids.index(k) }
    end

    def sorted_events_of_type(type_id)
      sorted_events_by_type.find { |v| v.first == type_id }&.last
    end

    def paginated_events_of_type(type_id, page, per_page = EVENTS_PER_TYPE)
      pages_by_type = { page_param_name(type_id) => page }
      paginated_events_by_type(pages_by_type, per_page).first { |v| v.first == type_id }&.last
    end

    def page_param_names
      event_type_ids.index_with { |type_id| page_param_name(type_id) }
    end

    def page_param_name(type_id)
      category_name = EventType.lookup_by_id(type_id)
      "#{category_name.parameterize(separator: '_')}_page"
    end

  private

    def merge_question_time_events(events_by_type)
      types = [EventType.train_to_teach_event_id, EventType.question_time_event_id]

      combined_events = events_by_type
        .select { |e| types.include?(e.type_id) }
        .map(&:teaching_events)
        .flatten

      return events_by_type if combined_events.blank?

      combined_events_type = GetIntoTeachingApiClient::TeachingEventsByType.new(
        type_id: EventType.train_to_teach_event_id,
        teaching_events: combined_events,
      )

      events_by_type
        .reject { |e| types.include?(e.type_id) }
        .push(combined_events_type)
    end

    def populate_events_by_type
      return @events_by_type unless @display_empty_types

      empty_state = event_type_ids.product([[]]).to_h
      empty_state.merge(@events_by_type)
    end

    def event_type_name(type_id)
      event_type_ids.index(type_id)
    end

    def event_type_ids
      EventType.all_ids - [EventType.question_time_event_id]
    end
  end
end
