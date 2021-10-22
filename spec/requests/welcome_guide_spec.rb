require "rails_helper"

describe "Find an event near you", type: :request do
  {
    "a42655a1-2afa-e811-a981-000d3a276620" => OpenStruct.new(subject: "Maths", name: "Dimitra"),
    "942655a1-2afa-e811-a981-000d3a276620" => OpenStruct.new(subject: "English", name: "Laura"),
    "802655a1-2afa-e811-a981-000d3a276620" => OpenStruct.new(subject: "Biology", name: "Holly"),
    "962655a1-2afa-e811-a981-000d3a276620" => OpenStruct.new(subject: "French", name: "Tom"),
  }.each do |subject_id, metadata|
    specify "shows #{metadata.subject}-specific content" do
      get("/welcome?preferred_teaching_subject_id=#{subject_id}")

      expect(response.body).to match(%r{teaching <mark>#{metadata.subject}.</mark>}i)
      expect(response.body).to match("Read #{metadata.name}'s story")
    end
  end
end
