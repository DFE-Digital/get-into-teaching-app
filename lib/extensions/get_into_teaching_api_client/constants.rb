module GetIntoTeachingApiClient
  module Constants
    EVENT_TYPES =
      {
        "Train to Teach event" => 222_750_001,
        "Online event" => 222_750_008,
        "School or University event" => 222_750_009,
      }.freeze

    EVENT_TYPES_WITH_ARCHIVE =
      {
        "Online event" => 222_750_008,
      }.freeze

    # This is not a complete list.
    EVENT_STATUS =
      {
        "Open" => 222_750_000,
        "Closed" => 222_750_001,
        "Pending" => 222_750_003,
      }.freeze

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
        "Maths" => "a42655a1-2afa-e811-a981-000d3a276620",
        "Pyhsics" => "ac2655a1-2afa-e811-a981-000d3a276620",
      }.freeze

    IGNORED_PREFERRED_TEACHING_SUBJECTS =
      {
        "Other" => "bc2655a1-2afa-e811-a981-000d3a276620",
        "No Preference" => "bc68e0c1-7212-e911-a974-000d3a206976",
      }.freeze
  end
end
