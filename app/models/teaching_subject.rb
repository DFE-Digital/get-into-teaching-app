class TeachingSubject
  ALL =
    {
      "Art" => "6b793433-cd1f-e911-a979-000d3a20838a",
      "Art and design" => "7e2655a1-2afa-e811-a981-000d3a276620",
      "Biology" => "802655a1-2afa-e811-a981-000d3a276620",
      "Business studies" => "822655a1-2afa-e811-a981-000d3a276620",
      "Chemistry" => "842655a1-2afa-e811-a981-000d3a276620",
      "Citizenship" => "862655a1-2afa-e811-a981-000d3a276620",
      "Classics" => "882655a1-2afa-e811-a981-000d3a276620",
      "Computing" => "8a2655a1-2afa-e811-a981-000d3a276620",
      "Dance" => "8c2655a1-2afa-e811-a981-000d3a276620",
      "Design and technology" => "8e2655a1-2afa-e811-a981-000d3a276620",
      "Drama" => "902655a1-2afa-e811-a981-000d3a276620",
      "Economics" => "922655a1-2afa-e811-a981-000d3a276620",
      "English" => "942655a1-2afa-e811-a981-000d3a276620",
      "French" => "962655a1-2afa-e811-a981-000d3a276620",
      "General science" => "982655a1-2afa-e811-a981-000d3a276620",
      "Geography" => "9a2655a1-2afa-e811-a981-000d3a276620",
      "German" => "9c2655a1-2afa-e811-a981-000d3a276620",
      "Health and social care" => "9e2655a1-2afa-e811-a981-000d3a276620",
      "History" => "a02655a1-2afa-e811-a981-000d3a276620",
      "Languages (other)" => "a22655a1-2afa-e811-a981-000d3a276620",
      "Maths" => "a42655a1-2afa-e811-a981-000d3a276620",
      "Media studies" => "a62655a1-2afa-e811-a981-000d3a276620",
      "Music" => "a82655a1-2afa-e811-a981-000d3a276620",
      "Physical education" => "aa2655a1-2afa-e811-a981-000d3a276620",
      "Physics" => "ac2655a1-2afa-e811-a981-000d3a276620",
      "Physics with maths" => "ae2655a1-2afa-e811-a981-000d3a276620",
      "Primary" => "b02655a1-2afa-e811-a981-000d3a276620",
      "Psychology" => "b22655a1-2afa-e811-a981-000d3a276620",
      "Religious education" => "b42655a1-2afa-e811-a981-000d3a276620",
      "Social sciences" => "b62655a1-2afa-e811-a981-000d3a276620",
      "Spanish" => "b82655a1-2afa-e811-a981-000d3a276620",
      "Vocational health" => "ba2655a1-2afa-e811-a981-000d3a276620",
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
