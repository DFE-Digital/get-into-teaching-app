class TeachingSubject
  # Not a complete list.
  ALL =
    {
      "Art and design" => "7e2655a1-2afa-e811-a981-000d3a276620",
      "Biology" => "802655a1-2afa-e811-a981-000d3a276620",
      "Chemistry" => "842655a1-2afa-e811-a981-000d3a276620",
      "English" => "942655a1-2afa-e811-a981-000d3a276620",
      "French" => "962655a1-2afa-e811-a981-000d3a276620",
      "General science" => "982655a1-2afa-e811-a981-000d3a276620",
      "German" => "9c2655a1-2afa-e811-a981-000d3a276620",
      "Languages (other)" => "a22655a1-2afa-e811-a981-000d3a276620",
      "Maths" => "a42655a1-2afa-e811-a981-000d3a276620",
      "Physics with maths" => "ae2655a1-2afa-e811-a981-000d3a276620",
      "Physics" => "ac2655a1-2afa-e811-a981-000d3a276620",
      "Spanish" => "b82655a1-2afa-e811-a981-000d3a276620",
    }.freeze

  IGNORED =
    {
      "Other" => "bc2655a1-2afa-e811-a981-000d3a276620",
      "No Preference" => "bc68e0c1-7212-e911-a974-000d3a206976",
    }.freeze

  class << self
    def lookup_by_key(key)
      keyed_subjects.fetch(key)
    end

    def lookup_by_keys(*keys)
      keyed_subjects.fetch_values(*keys)
    end

    def lookup_by_uuid(uuid)
      ALL.invert[uuid]
    end

    def key_with_uuid(uuid)
      keyed_subjects.invert[uuid]
    end

    def all_uuids
      ALL.values
    end

    def all_subjects
      ALL.keys
    end

    def ignore?(uuid)
      IGNORED.value?(uuid)
    end

    def keyed_subjects
      @keyed_subjects ||= ALL.transform_keys { |key| key.parameterize(separator: "_").to_sym }
    end
  end
end
