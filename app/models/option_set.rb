class OptionSet
  MAILING_LIST_CHANNELS =
    {
      "Careers Services activity" => 222_750_037,
      "Students Union Media" => 222_750_038,
    }.freeze

  DEGREE_STATUSES =
    {
      "Yes, I already have a degree" => 222_750_000,
      "Almost, I'm a final year student" => 222_750_001,
      "Not yet, I'm a second year student" => 222_750_002,
      "Not yet, I'm a first year student" => 222_750_003,
      "No, and I'm not studying for one" => 222_750_004,
      "Other" => 222_750_005,
    }.freeze

  CONSIDERATION_JOURNEY_STAGES =
    {
      "It's just an idea" => 222_750_000,
      "I'm not sure and finding out more" => 222_750_001,
      "I'm fairly sure and exploring my options" => 222_750_002,
      "I'm very sure and think I'll apply" => 222_750_003,
    }.freeze

  class << self
    def lookup_by_key(category, key)
      lookup_const(category).fetch(key)
    end

    def lookup_by_keys(category, *keys)
      lookup_const(category).fetch_values(*keys)
    end

    def lookup_by_value(category, value)
      lookup_const(category).invert.fetch(value)
    end

    def lookup_by_values(category, *values)
      lookup_const(category).invert.fetch_values(*values)
    end

    def lookup_const(category)
      const = const_get(category.to_s.pluralize.upcase)
      const.transform_keys { |k| k.parameterize(separator: "_").to_sym }
    end
  end
end
