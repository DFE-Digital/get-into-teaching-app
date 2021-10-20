require "rails_helper"

RSpec.describe WelcomeContentHelper, type: :helper do
  describe "#subject_specific_story_args" do
    {
      "a42655a1-2afa-e811-a981-000d3a276620" => "Dimitra", # meths
      "942655a1-2afa-e811-a981-000d3a276620" => "Laura",   # english
      "802655a1-2afa-e811-a981-000d3a276620" => "Holly",   # science
      "962655a1-2afa-e811-a981-000d3a276620" => "Tom",     # mfl
      "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee" => "Helen",   # generic
    }.each do |input, output|
      specify "returns the right content for each subject category" do
        expect(subject_specific_story_args(input).fetch(:name)).to eql(output)
      end
    end
  end
end
