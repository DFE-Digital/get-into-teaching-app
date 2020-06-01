module GetIntoTeachingApi
  class Event < Base
    attr_reader :event_id

    def initialize(event_id:, **base_args)
      @event_id = event_id
      super(**base_args)
    end

    def path
      "teaching_events/#{event_id}"
    end

    def call
      Types::Event.new data
    end
  end
end
