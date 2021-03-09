module Events
  class GroupPresenter
    EVENTS_PER_TYPE = 9

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
      category_name = GetIntoTeachingApiClient::Constants::EVENT_TYPES.key(type_id)
      "#{category_name.parameterize(separator: '_')}_page"
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
