require "rails_helper"

RSpec.describe WelcomeHelper, type: :helper do
  let(:physics_uuid) { "ac2655a1-2afa-e811-a981-000d3a276620" }

  describe "#greeting" do
    context "when the first name is known" do
      let(:name) { "Joey" }

      before { allow(session).to receive(:dig).with("mailinglist", "first_name") { name } }

      specify "returns a personalised greeting" do
        expect(greeting).to eql("Hey #{name}")
      end
    end

    context "when the first name isn't known" do
      specify "returns a generic greeting" do
        expect(greeting).to eql("Hello")
      end
    end
  end

  describe "#welcome_guide_subject" do
    subject { welcome_guide_subject }

    context "when overridden by the 'subject' query parameter" do
      before { allow_any_instance_of(ActionController::Parameters).to receive(:[]).and_return("842655a1-2afa-e811-a981-000d3a276620") }

      specify "returns the subject from the query param" do
        expect(subject).to eql("chemistry")
      end
    end

    context "when the subject is known" do
      context "when the subject name is a common noun" do
        GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS.slice("Art and design", "Biology", "Chemistry", "General science", "Languages (other)", "Maths", "Physics with maths", "Physics")
          .each do |subject_name, subject_id|
            describe "#{subject_name} is lowercased" do
              before { allow(session).to receive(:dig).with("mailinglist", "preferred_teaching_subject_id") { subject_id } }

              it { is_expected.to eql(subject_name.downcase) }
            end
          end
      end

      context "when the subject name is a proper noun" do
        GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS.slice("English", "German", "Spanish", "French")
          .each do |subject_name, subject_id|
            describe "#{subject_name} is not lowercased" do
              before { allow(session).to receive(:dig).with("mailinglist", "preferred_teaching_subject_id") { subject_id } }

              it { is_expected.to eql(subject_name) }
            end
          end
      end
    end

    context "when leave_capitalised is true" do
      subject { welcome_guide_subject(leave_capitalised: true) }

      before do
        allow(session).to receive(:dig).with("mailinglist", "preferred_teaching_subject_id").and_return(physics_uuid)
      end

      specify { is_expected.to eql("Physics") }
    end
  end

  describe "#teaching_subject" do
    subject { teaching_subject }

    context "when the subject is recognised" do
      before { allow(session).to receive(:dig).with("mailinglist", "preferred_teaching_subject_id").and_return(physics_uuid) }

      it { is_expected.to eql("teaching physics.") }

      context "when the subject is recognised and left capitalised" do
        subject { teaching_subject(leave_capitalised: true) }

        it { is_expected.to eql("teaching Physics.") }
      end

      context "when the mark subject is true" do
        subject { teaching_subject(mark_subject: true) }

        it { is_expected.to eql("teaching <mark>physics.</mark>") }
      end
    end

    context "when the subject is unset" do
      it { is_expected.to eql("<mark>teaching.</mark>") }
    end

    context "when the subject isn't recognised" do
      let(:fake_uuid) { "11111111-2222-3333-4444-555555555555" }

      before do
        allow(session).to(receive(:dig).with("mailinglist", "preferred_teaching_subject_id").and_return(fake_uuid))
      end

      it { is_expected.to eql("<mark>teaching.</mark>") }
    end
  end

  describe "#welcome_guide_subject_id" do
    subject { welcome_guide_subject }

    context "when overridden by the 'subject' query parameter" do
      let(:languages_uuid) { GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS["Languages (other)"] }

      before { allow_any_instance_of(ActionController::Parameters).to receive(:[]).and_return(languages_uuid) }

      specify "returns the subject from the query param" do
        expect(subject).to eql("languages (other)")
      end
    end

    context "when the subject id is in the mailinglist session param" do
      let(:german_uuid) { GetIntoTeachingApiClient::Constants::TEACHING_SUBJECTS["German"] }

      before { allow(session).to receive(:dig).with("mailinglist", "preferred_teaching_subject_id").and_return(german_uuid) }

      specify "returns the subject from the query param" do
        expect(subject).to eql("German")
      end
    end
  end
end
