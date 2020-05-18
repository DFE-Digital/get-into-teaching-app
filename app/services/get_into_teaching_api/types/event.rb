module GetIntoTeachingApi
  module Types
    class Event < Types::Base
      self.type_cast_rules = {
        "startDate" => :date,
        "endDate" => :date,
        "building" => EventBuilding,
        "room" => EventRoom
      }.freeze
    end
  end
end

