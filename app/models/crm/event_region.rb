class Crm::EventRegion
  ALL =
    {
      "East Midlands" => 222_750_000,
      "East of England" => 222_750_001,
      "London" => 222_750_002,
      "North East" => 222_750_003,
      "North West" => 222_750_004,
      "South East" => 222_750_005,
      "South West" => 222_750_006,
      "National" => 222_750_007,
      "West Midlands" => 222_750_008,
      "Yorkshire and the Humber" => 222_750_009,
      "Any" => 222_750_010,
    }.freeze

  class << self
    def lookup_by_id(id)
      ALL.invert.fetch(id)
    end

    def all_ids
      ALL.values
    end
  end
end
