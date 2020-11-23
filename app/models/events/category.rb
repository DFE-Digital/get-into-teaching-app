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

    def types_api
      GetIntoTeachingApiClient::TypesApi.new
    end

    def event_types
      @event_types = types_api.get_teaching_event_types
    end

    def events_api
      GetIntoTeachingApiClient::TeachingEventsApi.new
    end

    def type_id_for_category(category_name)
      category = event_types.index_by(&:value)[category_name.singularize]
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
        .upcoming_teaching_events_indexed_by_type(quantity_per_type: limit)
        .transform_keys { |k| k.to_s.to_i }
    end
  end
end
