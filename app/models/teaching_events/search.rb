module TeachingEvents
  class Search
    include ActiveModel::Model

    FUTURE_MONTHS = 6

    attr_accessor :postcode, :online, :type, :distance

    def results
      query.flat_map(&:teaching_events).sort_by(&:start_at)
    end

  private

    def query(limit: 12)
      conditions = {
        type_ids: type_condition,
        postcode: postcode_condition,
        online: online_condition,
        quantity_per_type: limit,
        radius: distance_condition,
        start_after: Time.zone.now,
        start_before: FUTURE_MONTHS.months.from_now,
      }

      Rails.logger.debug("search conditions: #{conditions}")

      GetIntoTeachingApiClient::TeachingEventsApi.new.search_teaching_events_grouped_by_type(**conditions)
    end

    def online_condition
      return nil if online.blank?

      # online is a pair of checkboxes for 'online' (true) and 'in_person' (false), so the
      # param will be something like: ["", "true", "false"]
      selection = online.reject(&:blank?).map { |r| ActiveModel::Type::Boolean.new.cast(r) }

      return nil if selection.empty?
      return true if selection.all?
      return false if selection.none?

      nil
    end

    def postcode_condition
      postcode.presence
    end

    def distance_condition
      return nil if distance.blank?

      distance.to_i
    end

    def type_condition
      return nil if type.blank?

      type.reject(&:blank?).flat_map { |t| t.split(",") }.map(&:to_i).presence
    end
  end
end
