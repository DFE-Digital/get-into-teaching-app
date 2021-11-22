module Events
  class Search
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations::Callbacks

    RESULTS_PER_TYPE = 9
    FUTURE_MONTHS = 24
    PAST_MONTHS = 4
    DISTANCES = [10, 25].freeze
    MONTH_FORMAT = %r{\A20[234]\d-(0[1-9]|1[012])\z}.freeze

    delegate :available_event_type_ids, :available_distance_keys, to: :class

    attribute :type, :integer
    attribute :distance, :integer
    attribute :postcode, :string
    attribute :month, :string
    attribute :period, default: :future

    validates :type, presence: false, inclusion: { in: :available_event_type_ids, allow_nil: true }
    validates :distance, inclusion: { in: :available_distance_keys }, allow_nil: true
    validates :postcode, presence: true, postcode: { allow_blank: true, accept_partial_postcode: true }, if: :distance
    validates :month, presence: false, format: { with: MONTH_FORMAT, allow_blank: true }
    validates :period, inclusion: { in: %i[past future] }

    before_validation { self.distance = nil if distance.blank? }
    before_validation(unless: :distance) { self.postcode = nil }

    before_validation if: :postcode do
      self.postcode = postcode.to_s.strip.upcase.presence
    end

    class << self
      def available_event_types
        # We can't search for Question Time events explicitly. Instead, they
        # are returned as Train to Teach events.
        @available_event_types ||= GetIntoTeachingApiClient::Constants::EVENT_TYPES
          .except("Question Time")
          .map do |key, value|
            GetIntoTeachingApiClient::PickListItem.new(id: value, value: key)
          end
      end

      def available_event_type_ids
        available_event_types.map(&:id)
      end

      def available_distance_keys
        available_distances.map(&:last)
      end

      def available_distances
        [["Nationwide", nil]] + DISTANCES.map { |d| ["Within #{d} miles", d] }
      end
    end

    def available_months
      @available_months ||= month_range.map do |i|
        month = month_at_index(i).to_date

        [
          month.to_formatted_s(:humanmonthyear),
          month.to_formatted_s(:yearmonth),
        ]
      end
    end

    def query_events(limit = RESULTS_PER_TYPE)
      valid? ? query_events_api(limit) : {}
    end

    def future?
      period == :future
    end

  private

    def type_ids
      type_ids = [type]

      # We combine Question Time events with Train to Teach events
      if type == GetIntoTeachingApiClient::Constants::EVENT_TYPES["Train to Teach event"]
        type_ids << GetIntoTeachingApiClient::Constants::EVENT_TYPES["Question Time"]
      end

      type_ids.compact.presence
    end

    def month_range
      return 0..FUTURE_MONTHS if future?

      start_month_index = today_start_of_month? ? -1 : 0
      start_month_index.downto(start_month_index - (PAST_MONTHS - 1)).to_a
    end

    def month_at_index(index)
      Time.zone.now.utc.advance(months: index)
    end

    def today_start_of_month?
      Time.zone.now.utc.day == 1
    end

    def query_events_api(limit)
      GetIntoTeachingApiClient::TeachingEventsApi.new.search_teaching_events_grouped_by_type(
        type_ids: type_ids,
        radius: distance,
        postcode: postcode&.strip,
        start_after: start_of_month,
        start_before: end_of_month,
        quantity_per_type: limit,
      )
    end

    def start_of_month
      return earliest_date_for_period if month.blank?

      date = Time.zone.parse("#{month}-01 00:00:00").in_time_zone("UTC")

      [date.beginning_of_month, earliest_date_for_period].max
    end

    def end_of_month
      return latest_date_for_period if month.blank?

      [start_of_month.end_of_month, latest_date_for_period].min
    end

    def earliest_date_for_period
      if future?
        Time.zone.now.utc.beginning_of_day
      else
        month_at_index(month_range.last).beginning_of_month
      end
    end

    def latest_date_for_period
      if future?
        month_at_index(month_range.last).end_of_month
      else
        Time.zone.now.utc.advance(days: -1).end_of_day
      end
    end
  end
end
