require "rails_helper"

describe "Welcome guide landing page", type: :request do
  {
    maths: OpenStruct.new(
      subject: "Maths",
      name: "Dimitra",
      quote_headline: "The highs are immeasurable",
      quote_body: "Gaming, sport, travelling",
    ),
    english: OpenStruct.new(
      subject: "English",
      name: "Laura",
      quote_headline: "From delving into literature",
      quote_body: "Those moments when kids suddenly get it",
    ),
    biology: OpenStruct.new(
      subject: "Biology",
      name: "Holly",
      quote_headline: "Plants, planets, protons",
      quote_body: "I value the way science teaches a clear thought process",
    ),
    french: OpenStruct.new(
      subject: "French",
      name: "Tom",
      quote_headline: "From delving into different cultures to discussing new ways of thinking",
      quote_body: "I get to travel still and can keep up with my languages",
    ),
  }.each do |subject_key, metadata|
    specify "shows #{metadata.subject || 'non'}-specific content" do
      subject_id = TeachingSubject.lookup_by_key(subject_key)
      get("/welcome?preferred_teaching_subject_id=#{subject_id}")

      expect(response.body).to match(%r{teaching <mark>#{metadata.subject}.</mark>}i)
      expect(response.body).to match("Read #{metadata.name}'s story")
      expect(response.body).to match(metadata.quote_headline)
      expect(response.body).to match(metadata.quote_body)
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
      subject_id = TeachingSubject.lookup_by_key(subject_key)
      get("/welcome/my-journey-into-teaching?preferred_teaching_subject_id=#{subject_id}")

      expect(response.body).to match(metadata.name)
      expect(response.body).to match(metadata.shoutout_name)
      expect(response.body).to match(metadata.shoutout_text)
      expect(response.body).to match(metadata.story_text)
    end
  end
end
