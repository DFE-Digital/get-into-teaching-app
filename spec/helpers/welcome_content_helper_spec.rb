require "rails_helper"

RSpec.describe WelcomeContentHelper, type: :helper do
  describe "#subject_specific_story_data" do
    {
      maths: "Dimitra",
      english: "Laura",
      biology: "Holly",
      french: "Tom",
    }.each do |key, name|
      specify "returns the right content for each subject category" do
        uuid = TeachingSubject.lookup_by_key(key)
        expect(subject_specific_story_data(uuid).fetch(:name)).to eql(name)
      end
    end

    specify "returns the generic content when the subject is not recognised" do
      uuid = "00000000-0000-0000-0000-000000000000"
      expect(subject_specific_story_data(uuid).fetch(:name)).to eql("Abigail")
    end
  end

  describe "#subject_category" do
    let(:id) { TeachingSubject.lookup_by_key(:english) }

    specify "returns the subject's category in lower case" do
      expect(subject_category(id)).to eql("english")
    end

    context "when downcase: false" do
      specify "returns the subject's category capitalised" do
        expect(subject_category(id, downcase: false)).to eql("English")
      end
    end
  end

  describe "#subject_specific_video_path" do
    specify "returns the given path for the matching subject" do
      physics_uuid = TeachingSubject.lookup_by_key(:physics)
      expect(subject_specific_video_path(physics_uuid)).to eql("/videos/welcome-guide-science.webm")
    end

    context "when the path is overridden" do
      specify "returns the given path for the matching subject" do
        french_uuid = TeachingSubject.lookup_by_key(:french)
        expect(subject_specific_video_path(french_uuid, prefix: "/blockbusters/")).to eql("/blockbusters/welcome-guide-mfl.webm")
      end
    end
  end
end
