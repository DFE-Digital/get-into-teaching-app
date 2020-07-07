module GetIntoTeachingApi
  module Types
    class Event < Types::Base
      self.type_cast_rules = {
        "startAt" => :datetime,
        "endAt" => :datetime,
        "building" => EventBuilding,
        "room" => EventRoom,
      }.freeze
    end
  end
end
