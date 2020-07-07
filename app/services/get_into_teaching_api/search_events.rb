module GetIntoTeachingApi
  class SearchEvents < Base
    def initialize(type_id:, radius_in_km:, postcode:, start_before:, start_after:, **base_args)
      @type_id = type_id
      @radius_in_km = radius_in_km
      @postcode = postcode
      @start_after = start_after
      @start_before = start_before
      super(**base_args)
    end

    def path
      "teaching_events/search"
    end

    def params
      {
        "TypeId" => @type_id,
        "RadiusInKm" => @radius_in_km,
        "Postcode" => @postcode,
        "StartAfter" => @start_after.xmlschema,
        "StartBefore" => @start_before.xmlschema,
      }
    end

    def call
      data.map do |event_data|
        Types::Event.new event_data
      end
    end
  end
end
