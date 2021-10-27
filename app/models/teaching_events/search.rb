module TeachingEvents
  class Search
    include ActiveModel::Model

    FUTURE_MONTHS = 6

    attr_accessor :postcode, :online, :type

    def results
      query.flat_map(&:teaching_events).sort_by(&:start_at)
    end

  private

    def query(limit: 12)
      GetIntoTeachingApiClient::TeachingEventsApi.new.search_teaching_events_grouped_by_type(
        type_ids: nil,
        postcode: postcode_condition,
        online: online_condition,
        quantity_per_type: limit,
        radius: nil,
        start_after: Time.zone.now,
        start_before: FUTURE_MONTHS.months.from_now,
      )
    end

    def online_condition
      return nil unless online

      selection = online.reject(&:blank?).map { |r| ActiveModel::Type::Boolean.new.cast(r) }

      return true if selection.all?
      return false if selection.none?

      nil
    end

    def postcode_condition
      postcode.presence
    end
  end
end
