module GetIntoTeachingApi
  module Constants
    DESCRIBE_YOURSELF_OPTIONS =
      {
        "Student" => "222750000",
        "Exploring my career options" => "222750001",
        "Looking to change career" => "222750002",
        "Not studying and no plans to" => "222750003",
      }.freeze

    DEGREE_STATUS_OPTIONS =
      {
        "Graduate or postgraduate" => "222750000",
        "Final year" => "222750001",
        "Second year" => "222750002",
        "First year" => "222750003",
        "I don't have a degree and am not studying for one" => "222750004",
        "Other" => "222750005",
      }.freeze

    CONSIDERATION_JOURNEY_STAGES =
      {
        "It’s just an idea" => "222750000",
        "I’m not sure and finding out more" => "222750001",
        "I’m fairly sure and exploring my options" => "222750002",
        "I’m very sure and think I’ll apply" => "222750003",
      }.freeze

    # This is not a complete list.
    TEACHING_SUBJECTS =
      {
        "Art and design" => "7e2655a1-2afa-e811-a981-000d3a276620",
        "Maths" => "a42655a1-2afa-e811-a981-000d3a276620",
        "Pyhsics" => "ac2655a1-2afa-e811-a981-000d3a276620",
        "No preference" => "bc68e0c1-7212-e911-a974-000d3a206976",
      }.freeze
  end
end
