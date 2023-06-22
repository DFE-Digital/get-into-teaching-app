class Crm::TeachingSubject
  RENAMED = {
    "Media studies" => "Communication and media studies",
    "General science" => "Science",
  }.freeze
  PRIMARY = "b02655a1-2afa-e811-a981-000d3a276620".freeze
  IGNORED =
    {
      "Art" => "6b793433-cd1f-e911-a979-000d3a20838a",
      "Physics with maths" => "ae2655a1-2afa-e811-a981-000d3a276620",
      "Vocational health" => "ba2655a1-2afa-e811-a981-000d3a276620",
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
      all_hash.invert[uuid]
    end

    def key_with_uuid(uuid)
      keyed_subjects.invert[uuid]
    end

    def all_uuids
      all_hash.values
    end

    def all_subjects
      all_hash.keys
    end

    def keyed_subjects
      all_hash.transform_keys { |key| key.parameterize(separator: "_").to_sym }
    end

    def all_hash
      all.to_h { |item| [item.value, item.id] }
    end

    def all_without_primary
      all_hash.reject { |_h, s| s == PRIMARY }
    end

    def all
      GetIntoTeachingApiClient::LookupItemsApi.new.get_teaching_subjects
        .reject(&method(:ignored?))
        .each(&method(:rename))
        .sort_by(&:value)
    end

  private

    def rename(subject)
      subject.value = RENAMED[subject.value] || subject.value
    end

    def ignored?(subject)
      IGNORED.value?(subject.id)
    end
  end
end
