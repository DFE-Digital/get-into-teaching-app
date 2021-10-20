module WelcomeContentHelper
  MATHS = {
    story: {
      name: "Dimitra",
      subject: "maths",
      image: "dimitra-desert-crop.jpg",
      text: "Meet Dimitra, find out how she got into teaching maths and what she's looking forward to next.",
    },
    quote: {
      headline: "Gaming, sport, travelling… it’s all about helping young people understand the world they live in. And setting them up to be skilled problem solvers. Who wouldn’t want to be part of that?",
      text: "The highs are immeasurable – like when a student who was struggling with maths suddenly puts their hand up to answer a question. That light-bulb moment really gives you a buzz",
      attribution: "Peter, maths teacher",
    },
  }.freeze

  SCIENCES = {
    story: {
      name: "Holly",
      subject: "science",
      image: "dimitra-desert-crop.jpg",
      text: "Meet Holly - find out how she got into teaching science and what she's looking forward to next.",
    },
    quote: {
      headline: "Plants, planets, protons… it’s all about sparking curiosity and challenging young minds to think about how the world works. You’ll be amazed at the questions students will start asking.",
      text: "I value the way science teaches a clear thought process and a way to make rational sense of the world. Plus, when you train to teach physics, you can get funding, which helped me afford it.",
      attribution: "Roger, science teacher",

    },
  }.freeze

  ENGLISH = {
    story: {
      name: "Laura",
      subject: "English",
      image: "dimitra-desert-crop.jpg",
      text: "Meet Laura - find out how she got into teaching English and how she became Head of Department in under 5 years.",
    },
    quote: {
      headline: "From delving into literature to exploring important life themes, it’s all about taking young minds on a journey as you encourage students to think for themselves. So, get set for some thought-provoking conversations you’ll never forget!",
      text: "Those moments when kids suddenly get it, where they grasp a concept, that’s when you’re creating change. I can’t think of any other job where you can have that impact.",
      attribution: "David, English teacher",
    },
  }.freeze

  MFL = {
    story: {
      name: "Tom",
      subject: "languages",
      image: "dimitra-desert-crop.jpg",
      text: "Meet Tom - find out how he got into teaching Spanish and what he's looking forward to next.",
    },
    quote: {
      headline: "From delving into different cultures to discussing new ways of thinking, it’s all about taking young minds on a journey out of the classroom. So, get set for some fun and memorable conversations!",
      text: "There’s a lot of sharing of stories and the kids can be so funny, they really crack me up. Plus, I enjoy the holidays. I get to travel still and can keep up with my languages.",
      attribution: "Jacqui, modern foreign languages teacher",
    },
  }.freeze

  GENERIC = {
    story: {
      name: "Helen",
      subject: nil,
      image: "dimitra-desert-crop.jpg",
      text: "Meet Helen - find out how she went from trainee to Assistant Headteacher and what she's looking forward to next.",
    },
    quote: {
      headline: "It’s all about sparking curiosity and challenging young minds, inspiring them to really think about how the world works. You’ll be amazed at the questions students will start asking, all because of you.",
      text: "Let your passion and your confidence as a potential teacher speak out, not your fears. Don’t get disappointed if something goes wrong, go back and try to improve your skills. It’s a fantastic role in this world to shape minds.",
      attribution: "Raluca-Ecaterina Pupaza, trainee teacher",
      video: nil,
    },
  }.freeze

  def subject_specific_story_data(id = welcome_guide_subject_id)
    mappings(id).fetch(:story)
  end

  def subject_specific_quote_data(id = welcome_guide_subject_id)
    mappings(id).fetch(:quote)
  end

private

  def mappings(id)
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
    }.fetch(id) { GENERIC }
  end
end
