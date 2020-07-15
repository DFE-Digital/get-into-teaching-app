module Events
  class Search
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations::Callbacks

    DISTANCES = [30, 50, 100].freeze
    MONTH_FORMAT = %r{\A20[234]\d-(0[1-9]|1[012])\z}.freeze

    attribute :type, :integer
    attribute :distance, :integer
    attribute :postcode, :string
    attribute :month, :string

    validates :type, presence: true, inclusion: { in: :available_event_type_ids, allow_blank: true }
    validates :distance, inclusion: { in: :available_distance_keys }, allow_nil: true
    validates :postcode, presence: true, postcode: { allow_blank: true }, if: :distance
    validates :month, presence: true, format: { with: MONTH_FORMAT, allow_blank: true }

    before_validation { self.distance = nil if distance.blank? }
    before_validation(unless: :distance) { self.postcode = nil }

    def available_event_types
      @available_event_types ||= query_event_types
    end

    def available_event_type_ids
      available_event_types.map(&:id).map(&:to_i)
    end

    def available_distances
      [["Nationwide", nil]] + DISTANCES.map { |d| ["Within #{d} miles", d] }
    end

    def available_distance_keys
      available_distances.map(&:last)
    end

    def available_months
      (0..5).map do |i|
        month = i.months.from_now.to_date

        [
          month.to_formatted_s(:humanmonthyear),
          month.to_formatted_s(:yearmonth),
        ]
      end
    end

    def query_events
      valid? ? query_events_api : []
    end

  private

    def query_events_api
      GetIntoTeachingApi::Client.search_events \
        type_id: type,
        radius: distance,
        postcode: postcode,
        start_after: start_of_month,
        start_before: end_of_month
    end

    def query_event_types
      # GetIntoTeachingApi::Client.event_types
      GetIntoTeachingApiClient::TypesApi.new.get_teaching_event_types
    end

    def start_of_month
      DateTime.parse("#{month}-01 00:00:00").beginning_of_month
    end

    def end_of_month
      start_of_month.end_of_month
    end
  end
end
