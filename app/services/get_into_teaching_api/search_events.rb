module GetIntoTeachingApi
  class SearchEvents < Base
    def initialize(type:, distance:, postcode:, month:, **base_args)
      @type = type
      @distance = distance
      @postcode = postcode
      @month = month
      super(**base_args)
    end

    def path
      "teaching_events/search"
    end

    def params
      {
        type: @type,
        distance: @distance,
        postcode: @postcode,
        month: @month,
      }
    end

    def call
      data.map do |event_data|
        Types::Event.new event_data
      end
    end
  end
end
