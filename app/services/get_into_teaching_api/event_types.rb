module GetIntoTeachingApi
  class EventTypes < Base
    def path
      "types/teaching_event/types"
    end

    def call
      data.map { |d| Types::EventType.new d }
    end
  end
end
