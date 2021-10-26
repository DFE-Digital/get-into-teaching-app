require "rails_helper"

RSpec.describe WelcomeContentHelper, type: :helper do
  describe "#subject_specific_story_data" do
    {
      "a42655a1-2afa-e811-a981-000d3a276620" => "Dimitra", # meths
      "942655a1-2afa-e811-a981-000d3a276620" => "Laura",   # english
      "802655a1-2afa-e811-a981-000d3a276620" => "Holly",   # science
      "962655a1-2afa-e811-a981-000d3a276620" => "Tom",     # mfl
      "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee" => "Helen",   # generic
    }.each do |input, output|
      specify "returns the right content for each subject category" do
        expect(subject_specific_story_data(input).fetch(:name)).to eql(output)
      end
    end
  end

  describe "subject_category" do
    let(:id) { "942655a1-2afa-e811-a981-000d3a276620" }

    specify "returns the subject's category in lower case" do
      expect(subject_category(id)).to eql("english")
    end

    context "when downcase: false" do
      specify "returns the subject's category capitalised" do
        expect(subject_category(id, downcase: false)).to eql("English")
      end
    end
  end
end
