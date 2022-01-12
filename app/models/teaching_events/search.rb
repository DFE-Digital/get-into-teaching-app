module TeachingEvents
  class Search
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations::Callbacks

    FUTURE_MONTHS = 6

    DISTANCES = {
      "Nationwide" => nil,
      "5 miles" => 5,
      "10 miles" => 10,
      "30 miles" => 30,
      "50 miles" => 50,
    }.freeze

    attr_accessor :online, :type

    attribute :postcode, :string
    attribute :distance, :integer

    validates :postcode, presence: true, postcode: { allow_blank: true, accept_partial_postcode: true }, if: :distance
    validates :distance, inclusion: { in: DISTANCES.values }, allow_nil: true

    before_validation { self.distance = nil if distance.blank? }
    before_validation { self.postcode = postcode.to_s.strip.upcase.presence }

    def results
      query.flat_map(&:teaching_events).sort_by(&:start_at)
    end

  private

    def query(limit: 100)
      conditions = {
        type_ids: type_condition,
        postcode: postcode_condition,
        online: online_condition,
        quantity_per_type: limit,
        radius: distance_condition,
        start_after: start_after,
        start_before: start_before,
      }

      GetIntoTeachingApiClient::TeachingEventsApi.new.search_teaching_events_grouped_by_type(**conditions)
    end

    def start_after
      Time.zone.now
    end

    def start_before
      FUTURE_MONTHS.months.from_now
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
