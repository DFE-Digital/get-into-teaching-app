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
  end
end
