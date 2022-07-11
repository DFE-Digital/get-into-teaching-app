require "rails_helper"

describe "Welcome guide landing page", type: :request do
  {
    maths: OpenStruct.new(
      subject: "Maths",
      name: "Dimitra",
      quote_headline: "The highs are immeasurable",
      quote_body: "Gaming, sport, travelling",
      we_need_subject_teachers: "we need maths teachers",
    ),
    english: OpenStruct.new(
      subject: "English",
      name: "Laura",
      quote_headline: "From delving into literature",
      quote_body: "Those moments when kids suddenly get it",
      we_need_subject_teachers: "we need English teachers",
    ),
    biology: OpenStruct.new(
      subject: "Biology",
      name: "Holly",
      quote_headline: "Plants, planets, protons",
      quote_body: "I value the way science teaches a clear thought process",
      we_need_subject_teachers: "we need biology teachers",
    ),
    french: OpenStruct.new(
      subject: "French",
      name: "Tom",
      quote_headline: "From delving into different cultures to discussing new ways of thinking",
      quote_body: "I get to travel still and can keep up with my languages",
      we_need_subject_teachers: "we need French teachers",
    ),
  }.each do |subject_key, metadata|
    specify "shows #{metadata.subject || 'non'}-specific content" do
      get("/welcome/email/subject/#{subject_key}")

      expect(response.body).to match(%r{teaching <mark>#{metadata.subject}.</mark>}i)
      expect(response.body).to match("Read #{metadata.name}'s story")
      expect(response.body).to match(metadata.quote_headline)
      expect(response.body).to match(metadata.quote_body)
      expect(response.body).to match(metadata.we_need_subject_teachers)
    end
  end

  {
    maths: OpenStruct.new(
      name: "Dimitra",
      shoutout_name: "Alison Conner",
      shoutout_text: "When I doubted myself, she believed in me",
      story_text: "I've always found it fascinating learning how maths shapes the world",
    ),
    english: OpenStruct.new(
      name: "Laura",
      shoutout_name: "Ms Colley",
      shoutout_text: "She left such a strong imprint on me",
      story_text: "Going to uni wasn't the norm where I'm from",
    ),
    biology: OpenStruct.new(
      name: "Holly",
      shoutout_name: "Mr Eaves",
      shoutout_text: "he would never give up",
      story_text: "I really enjoyed the coaching aspect of the degree",
    ),
    french: OpenStruct.new(
      subject: "French",
      name: "Tom",
      shoutout_name: "Ms Langley and Ms Meredith",
      shoutout_text: "I was totally in awe of my GCSE and A Level Spanish teachers",
      story_text: "Some of my friends were going into office jobs",
    ),
  }.each do |subject_key, metadata|
    specify "shows #{metadata.subject || 'non'}-specific case study content" do
      get("/welcome/email/subject/#{subject_key}")
      get("/welcome/my-journey-into-teaching")

      expect(response.body).to include(metadata.name)
      expect(response.body).to include(metadata.shoutout_name)
      expect(response.body).to include(metadata.shoutout_text)
      expect(response.body).to include(metadata.story_text)
    end
  end
end
