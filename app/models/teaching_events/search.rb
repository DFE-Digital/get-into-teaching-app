module TeachingEvents
  class Search
    include ActiveModel::Model

    attr_accessor :postcode, :setting, :type

    def results
      query.flat_map(&:teaching_events)
    end

  private

    def query(limit: 12)
      GetIntoTeachingApiClient::TeachingEventsApi.new.search_teaching_events_grouped_by_type(
        type_ids: GetIntoTeachingApiClient::Constants::EVENT_TYPES.values,
        postcode: postcode,
        limit: limit,
      )
    end
  end
end
