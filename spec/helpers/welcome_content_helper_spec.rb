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

  describe "#subject_specific_video_paths" do
    specify "preloads the first few frames of the video so a poster is displayed" do
      subject_uuid = TeachingSubject.lookup_by_key(:physics)
      expect(subject_specific_video_paths(subject_uuid)).to all(end_with("#t=0.1"))
    end

    specify "returns the given paths for the matching subject" do
      physics_uuid = TeachingSubject.lookup_by_key(:physics)
      expect(subject_specific_video_paths(physics_uuid)).to contain_exactly(
        "/videos/welcome-guide-science.mp4#t=0.1",
        "/videos/welcome-guide-science.webm#t=0.1",
      )
    end

    context "when the path is overridden" do
      specify "returns the given path for the matching subject" do
        french_uuid = TeachingSubject.lookup_by_key(:french)
        expect(subject_specific_video_paths(french_uuid, prefix: "/blockbusters/")).to contain_exactly(
          "/blockbusters/welcome-guide-mfl.mp4#t=0.1",
          "/blockbusters/welcome-guide-mfl.webm#t=0.1",
        )
      end
    end
  end

  describe "#is_featured_subject?" do
    context "when the subject has a mapping" do
      subject { featured_subject?(TeachingSubject.lookup_by_key(:physics)) }

      specify { expect(subject).to be(true) }
    end

    context "when the subject has no mapping" do
      subject { featured_subject?(TeachingSubject.lookup_by_key(:music)) }

      specify { expect(subject).to be(false) }
    end
  end
end
