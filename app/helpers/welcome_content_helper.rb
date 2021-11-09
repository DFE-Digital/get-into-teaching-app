module WelcomeContentHelper
  MATHS = {
    video: "welcome-guide-generic.webm",
    story: {
      name: "Dimitra",
      job_title_and_location: "maths teacher, London",
      subject: "maths",
      image: "dimitra-desert-crop.jpg",
      alt: "Maths teacher Dimitra standing in front of some sand dunes",
      text: "Meet Dimitra, find out how she got into teaching maths and what she's looking forward to next.",
      three_things_youll_never_hear_me_say: {
        "Every day is the same" => "One day I’ll be playing bingo to make maths fun, the next exploring how maths underpins the economy.",
        "I miss adult conversation" => "At every school I’ve worked in, the teachers have always been super supportive. We love to have a laugh too. Weekly pub visits are the norm!",
        "Work never stops" => "When the school day ends, I switch off and focus on my own stuff. I value my down time a lot. Plus, I make the most of the longer holiday and spend most summers in Greece.",
      },
      shoutout: {
        name: "Alison Conner",
        relationship: "my mentor",
        text: "When I doubted myself, she believed in me. She’s a maths teacher too, and has always been so supportive. I’m lucky that we still work in the same school!",
      },
    },
    quote: {
      headline: "Gaming, sport, travelling… it’s all about helping young people understand the world they live in. And setting them up to be skilled problem solvers. Who wouldn’t want to be part of that?",
      text: "The highs are immeasurable – like when a student who was struggling with maths suddenly puts their hand up to answer a question. That light-bulb moment really gives you a buzz",
      attribution: "Peter, maths teacher",
    },
  }.freeze

  SCIENCES = {
    video: "welcome-guide-science.webm",
    story: {
      name: "Holly",
      job_title_and_location: "science teacher, Essex",
      subject: "science",
      image: "dimitra-desert-crop.jpg",
      alt: "Science teacher Holly",
      text: "Meet Holly - find out how she got into teaching science and what she's looking forward to next.",
      three_things_youll_never_hear_me_say: {
        "Every day is the same" => "From practical experiments to acting out elements in the classroom, I love exploring new ways to teach. The kids love getting involved and seeing them enjoying it always makes me smile",
        "I miss adult conversation" => "My colleagues are great. We spend breaks and lunchtimes catching up in the staff room. It is really a family dynamic and we’ve had some great socials – bowling is a personal favourite.",
        "Work never stops" => "When the school day ends, I get to switch off. I love to sail and I play in a netball league (strictly no students allowed!). It’s important to have a life outside of the classroom.",
      },
      shoutout: {
        name: "Mr Eaves",
        relationship: "my maths teacher",
        text: "Even if it took extra time and effort, he would never give up until everyone in the class ‘got it’. This was my motivation; I want to be able to do that for my students. Thank you!",
      },
    },
    quote: {
      headline: "Plants, planets, protons… it’s all about sparking curiosity and challenging young minds to think about how the world works. You’ll be amazed at the questions students will start asking.",
      text: "I value the way science teaches a clear thought process and a way to make rational sense of the world. Plus, when you train to teach physics, you can get funding, which helped me afford it.",
      attribution: "Roger, science teacher",

    },
  }.freeze

  ENGLISH = {
    video: "welcome-guide-generic.webm",
    story: {
      name: "Laura",
      job_title_and_location: "English teacher, Doncaster",
      subject: "English",
      image: "dimitra-desert-crop.jpg",
      alt: "English teacher Laura",
      text: "Meet Laura - find out how she got into teaching English and how she became Head of Department in under 5 years.",
      three_things_youll_never_hear_me_say: {
        "Every day is the same" => "Not! I’m always looking for ways to get my class excited, whether it's acting out Blood Brothers or discussing the many different interpretations of Alice in Wonderland.",
        "I miss adult conversation" => "I get on so well with the other teachers, we’re great friends and we're always chatting on WhatsApp. We’ve even got a karaoke night coming up, I can’t wait!",
        "Work never stops" => "My school has a great policy of no emails after 6pm, so it means when the school day ends, I can shut my laptop and get back to being me (and mum!)",
      },
      shoutout: {
        name: "Ms Colley",
        relationship: "my English teacher at school",
        text: "Ms Colley, my English teacher at school. She left such a strong imprint on me and really instilled a love of reading. I’ll never forget her, she showed me what I could achieve.",
      },
    },
    quote: {
      headline: "From delving into literature to exploring important life themes, it’s all about taking young minds on a journey as you encourage students to think for themselves. So, get set for some thought-provoking conversations you’ll never forget!",
      text: "Those moments when kids suddenly get it, where they grasp a concept, that’s when you’re creating change. I can’t think of any other job where you can have that impact.",
      attribution: "David, English teacher",
    },
  }.freeze

  MFL = {
    video: "welcome-guide-mfl.webm",
    story: {
      name: "Tom",
      job_title_and_location: "Spanish teacher, Coventry",
      subject: "languages",
      image: "dimitra-desert-crop.jpg",
      alt: "Spanish teacher Tom",
      text: "Meet Tom - find out how he got into teaching Spanish and what he's looking forward to next.",
      three_things_youll_never_hear_me_say: {
        "Every day is the same" => "From exploring Latin American culture to reading Spanish literature, every lesson is different. And with 30 different personalities in one room, it’s never dull",
        "I miss adult conversation" => "Some of my closest friends are my colleagues, and having someone to talk to makes work life so much easier. Our trips to the pub at the end of the week are something I always look forward to.",
        "Work never stops" => "It’s important to relax after school,  I can’t resist watching a good Spanish film on Netflix.  And I'm still an avid traveller, I love exploring other cultures.",
      },
      shoutout: {
        name: "Ms Langley and Ms Meredith",
        relationship: "my Spanish teachers at school",
        text: "I was totally in awe of my GCSE and A Level Spanish teachers. I loved hearing about their experiences and love of language. It definitely had an impact on my decision to study Spanish at university. We’ve stayed in touch and I still turn to them for advice or ideas when I need. Thank you!",
      },
    },
    quote: {
      headline: "From delving into different cultures to discussing new ways of thinking, it’s all about taking young minds on a journey out of the classroom. So, get set for some fun and memorable conversations!",
      text: "There’s a lot of sharing of stories and the kids can be so funny, they really crack me up. Plus, I enjoy the holidays. I get to travel still and can keep up with my languages.",
      attribution: "Jacqui, modern foreign languages teacher",
    },
  }.freeze

  GENERIC = {
    video: "welcome-guide-generic.webm",
    story: {
      name: "Abigail",
      job_title_and_location: "head of maths, Wigan",
      subject: nil,
      image: "dimitra-desert-crop.jpg",
      alt: "Head of maths, Abigail",
      text: "Meet Abigail - find out how she went from trainee to head of department and what she’s looking forward to next.",
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

  def subject_specific_video_path(id = welcome_guide_subject_id, prefix: "/videos/")
    prefix + mappings(id).fetch(:video)
  end

  def subject_category(id = welcome_guide_subject_id, downcase: true)
    category = mappings(id).dig(:story, :subject)

    category && downcase ? category.downcase : category
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
