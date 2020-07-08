module GetIntoTeachingApi
  module Types
    class KeyValue < Types::Base
      self.type_cast_rules = {
        "id" => :integer,
      }
    end
  end
end
