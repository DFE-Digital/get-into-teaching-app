module GetIntoTeachingApi
  class UpcomingEvents < Base
    def path
      "teaching_events/upcoming"
    end

    def call
      data.map do |event_data|
        Types::Event.new event_data
      end
    end
  end
end
