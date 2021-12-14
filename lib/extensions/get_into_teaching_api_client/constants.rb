module GetIntoTeachingApiClient
  module Constants
    # This is not a complete list.
    CANDIDATE_MAILING_LIST_SUBSCRIPTION_CHANNELS =
      {
        "GITIS - On Campus - Careers Services activity" => 222_750_037,
        "GITIS - On Campus - Students Union Media" => 222_750_038,
      }.freeze

    DEGREE_STATUS_OPTIONS =
      {
        "Graduate or postgraduate" => 222_750_000,
        "Final year" => 222_750_001,
        "Second year" => 222_750_002,
        "First year" => 222_750_003,
        "I don't have a degree and am not studying for one" => 222_750_004,
        "Other" => 222_750_005,
      }.freeze

    CONSIDERATION_JOURNEY_STAGES =
      {
        "It’s just an idea" => 222_750_000,
        "I’m not sure and finding out more" => 222_750_001,
        "I’m fairly sure and exploring my options" => 222_750_002,
        "I’m very sure and think I’ll apply" => 222_750_003,
      }.freeze

    # This is not a complete list.
    TEACHING_SUBJECTS =
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

    IGNORED_PREFERRED_TEACHING_SUBJECTS =
      {
        "Other" => "bc2655a1-2afa-e811-a981-000d3a276620",
        "No Preference" => "bc68e0c1-7212-e911-a974-000d3a206976",
      }.freeze
  end
end
