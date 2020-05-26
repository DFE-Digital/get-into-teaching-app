module Events
  class Search
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations::Callbacks

    DISTANCES = [30, 50, 100].freeze
    MONTH_FORMAT = %r{\A20[234]\d-(0[1-9]|1[012])\z}.freeze
    EVENT_TYPES = [0, 1].freeze

    attribute :event_type, :integer
    attribute :distance, :integer
    attribute :location, :string
    attribute :month, :string

    validates :event_type, presence: true, inclusion: { in: EVENT_TYPES }
    validates :distance, inclusion: { in: DISTANCES }, allow_nil: true
    validates :location, presence: true, postcode: true, if: :distance
    validates :month, presence: true, format: { with: MONTH_FORMAT }

    before_validation(unless: :distance) { self.location = nil }

    def query_events
      valid? ? query_events_api : []
    end

  private

    def query_events_api
      []
    end
  end
end
