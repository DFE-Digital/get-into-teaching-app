module WelcomeContentHelper
  MATHS = {
    name: "Dimitra",
    subject: "maths",
    image: "dimitra-desert-crop.jpg",
    text: "Meet Dimitra, find out how she got into teaching maths and what she's looking forward to next.",
  }.freeze

  SCIENCES = {
    name: "Holly",
    subject: "science",
    image: "dimitra-desert-crop.jpg",
    text: "Meet Holly - find out how she got into teaching science and what she's looking forward to next.",
  }.freeze

  ENGLISH = {
    name: "Laura",
    subject: "English",
    image: "dimitra-desert-crop.jpg",
    text: "Meet Laura - find out how she got into teaching English and how she became Head of Department in under 5 years.",
  }.freeze

  MFL = {
    name: "Tom",
    subject: "languages",
    image: "dimitra-desert-crop.jpg",
    text: "Meet Tom - find out how he got into teaching Spanish and what he's looking forward to next.",
  }.freeze

  GENERIC = {
    name: "Helen",
    subject: nil,
    image: "dimitra-desert-crop.jpg",
    text: "Meet Helen - find out how she went from trainee to Assistant Headteacher and what she's looking forward to next.",
  }.freeze

  def subject_specific_args
    {
      "a42655a1-2afa-e811-a981-000d3a276620" => MATHS,
      "942655a1-2afa-e811-a981-000d3a276620" => ENGLISH,

      "802655a1-2afa-e811-a981-000d3a276620" => SCIENCES,  # biology
      "842655a1-2afa-e811-a981-000d3a276620" => SCIENCES,  # chemistry
      "ac2655a1-2afa-e811-a981-000d3a276620" => SCIENCES,  # physics
      "ae2655a1-2afa-e811-a981-000d3a276620" => SCIENCES,  # physics with maths
      "982655a1-2afa-e811-a981-000d3a276620" => SCIENCES,  # general science

      "962655a1-2afa-e811-a981-000d3a276620" => MFL,       # french
      "9c2655a1-2afa-e811-a981-000d3a276620" => MFL,       # german
      "b82655a1-2afa-e811-a981-000d3a276620" => MFL,       # spanish
      "a22655a1-2afa-e811-a981-000d3a276620" => MFL,       # languages (other)
    }.fetch(welcome_guide_subject_id) { GENERIC }
  end
end
