module GetIntoTeachingApi
  class UpcomingEvents < Base
    def path
      "teaching_events/upcoming"
    end

    def events
      data.map do |event_data|
        building = OpenStruct.new(event_data["building"])
        room = OpenStruct.new(event_data["room"])
        OpenStruct.new event_data.merge("building" => building, "room" => room)
      end
    end
  end
end
