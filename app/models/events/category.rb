module Events
  class Category
    attr_reader :id

    def initialize(id_or_name)
      @id = if id_or_name.to_s.match? %r{\A\d+\z}
              check_type_id(id_or_name.to_i)
            else
              type_id_for_category(id_or_name).to_i
            end
    end

    def latest
      query_events(1)[id]&.first
    end

    class UnknownEventCategory < RuntimeError; end

  private

    def pick_list_items_api
      GetIntoTeachingApiClient::PickListItemsApi.new
    end

    def event_types
      @event_types = pick_list_items_api.get_teaching_event_types
    end

    def events_api
      GetIntoTeachingApiClient::TeachingEventsApi.new
    end

    def type_id_for_category(category_name)
      category = indexed_categories[normalize_name(category_name)]
      category ? category.id.to_i : raise(UnknownEventCategory)
    end

    def check_type_id(type_id)
      if event_types.map(&:id).map(&:to_i).include?(type_id)
        type_id
      else
        raise UnknownEventCategory
      end
    end

    def query_events(limit)
      events_api
        .search_teaching_events_grouped_by_type(
          quantity_per_type: limit,
          start_after: Time.zone.now.utc.beginning_of_day,
        )
        .index_by(&:type_id)
        .transform_values(&:teaching_events)
    end

    def normalize_name(name)
      name.singularize.downcase
    end

    def indexed_categories
      event_types
        .index_by(&:value)
        .transform_keys(&method(:normalize_name))
    end
  end
end
