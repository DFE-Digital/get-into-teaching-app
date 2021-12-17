require "rails_helper"

RSpec.describe WelcomeHelper, type: :helper do
  let(:physics_uuid) { TeachingSubject.lookup_by_key(:physics) }

  shared_context "with first name" do
    before { allow(session).to receive(:dig).with("mailinglist", "first_name") { name } }
  end

  shared_context "with preferred teaching subject set in welcome_guide" do
    before { allow(session).to receive(:dig).with("welcome_guide", "preferred_teaching_subject_id") { subject_id } }
  end

  shared_context "with preferred teaching subject set in welcome_guide and mailinglist" do
    before do
      allow(session).to receive(:dig).with("welcome_guide", "preferred_teaching_subject_id").and_return(nil)
      allow(session).to receive(:dig).with("mailinglist", "preferred_teaching_subject_id") { subject_id }
    end
  end

  describe "#show_welcome_guide?" do
    context "when degree_status is second year" do
      let(:second_year) { GetIntoTeachingApiClient::Constants::DEGREE_STATUS_OPTIONS["Second year"] }

      it { expect(show_welcome_guide?(second_year)).to be false }
    end

    context "when degree_status is final year" do
      let(:final_year) { GetIntoTeachingApiClient::Constants::DEGREE_STATUS_OPTIONS["Final year"] }

      it { expect(show_welcome_guide?(final_year)).to be true }
    end

    context "when degree_status is 'graduate or postgraduate'" do
      let(:graduate) { GetIntoTeachingApiClient::Constants::DEGREE_STATUS_OPTIONS["Graduate or postgraduate"] }

      context "when consideration journey stage is 'it's just an idea'" do
        let(:just_an_idea) { GetIntoTeachingApiClient::Constants::CONSIDERATION_JOURNEY_STAGES["It’s just an idea"] }

        it { expect(show_welcome_guide?(graduate, just_an_idea)).to be true }
      end

      context "when consideration journey stage is 'I’m not sure and finding out more'" do
        let(:finding_out_more) { GetIntoTeachingApiClient::Constants::CONSIDERATION_JOURNEY_STAGES["I’m not sure and finding out more"] }

        it { expect(show_welcome_guide?(graduate, finding_out_more)).to be true }
      end

      context "when consideration journey stage is 'I’m fairly sure and exploring my options'" do
        let(:fairly_sure) { GetIntoTeachingApiClient::Constants::CONSIDERATION_JOURNEY_STAGES["I’m fairly sure and exploring my options"] }

        it { expect(show_welcome_guide?(graduate, fairly_sure)).to be false }
      end
    end
  end

  describe "#greeting" do
    context "when the first name is known" do
      let(:name) { "Joey" }

      include_context "with first name"

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

    include_context "with preferred teaching subject set in welcome_guide"

    context "when set by query param and stored in the welcome_guide session store" do
      include_context "with preferred teaching subject set in welcome_guide"

      let(:subject_id) { TeachingSubject.lookup_by_key(:chemistry) }

      specify "returns the correct subject" do
        expect(subject).to eql("chemistry")
      end
    end

    context "when stored in the mailinglist session store" do
      context "when the subject name is a common noun" do
        %i[art_and_design biology chemistry general_science languages_other maths physics_with_maths physics].each do |subject_key|
          describe "#{subject_key} is lowercased" do
            let(:subject_id) { TeachingSubject.lookup_by_key(subject_key) }

            include_context "with preferred teaching subject set in welcome_guide"

            it { is_expected.to eql(TeachingSubject.lookup_by_uuid(subject_id).downcase) }
          end
        end
      end

      context "when the subject name is a proper noun" do
        %i[english german spanish french].each do |subject_key|
          describe "#{subject_key} is not lowercased" do
            let(:subject_id) { TeachingSubject.lookup_by_key(subject_key) }

            include_context "with preferred teaching subject set in welcome_guide"

            it { is_expected.to eql(TeachingSubject.lookup_by_uuid(subject_id)) }
          end
        end
      end
    end

    context "when leave_capitalised is true" do
      subject { welcome_guide_subject(leave_capitalised: true) }

      let(:subject_id) { physics_uuid }

      before do
        allow(session).to receive(:dig).with("mailinglist", "preferred_teaching_subject_id").and_return(physics_uuid)
      end

      specify { is_expected.to eql("Physics") }
    end
  end

  describe "#teaching_subject" do
    subject { teaching_subject }

    let(:subject_id) { physics_uuid }

    context "when the subject is recognised" do
      include_context "with preferred teaching subject set in welcome_guide"

      it { is_expected.to eql("teaching physics.") }

      context "when the subject is recognised and left capitalised" do
        subject { teaching_subject(leave_capitalised: true) }

        it { is_expected.to eql("teaching Physics.") }
      end

      context "when the mark subject is true" do
        subject { teaching_subject(mark_tag: true) }

        it { is_expected.to eql("teaching <mark>physics.</mark>") }
      end
    end

    context "when the subject is unset" do
      it { is_expected.to eql("teaching.") }
    end

    context "when the subject isn't recognised" do
      let(:fake_uuid) { "11111111-2222-3333-4444-555555555555" }

      before do
        allow(session).to(receive(:dig).with("mailinglist", "preferred_teaching_subject_id").and_return(fake_uuid))
        allow(session).to(receive(:dig).with("welcome_guide", "preferred_teaching_subject_id").and_return(fake_uuid))
      end

      it { is_expected.to eql("teaching.") }
    end
  end

  describe "#welcome_guide_subject_id" do
    subject { welcome_guide_subject }

    context "when the subject id is in the welcome_guide session store" do
      let(:subject_id) { TeachingSubject.lookup_by_key(:languages_other) }

      include_context "with preferred teaching subject set in welcome_guide"

      specify "returns the subject from the query param" do
        expect(subject).to eql("languages (other)")
      end
    end

    context "when the subject id is in the mailinglist session store" do
      let(:subject_id) { TeachingSubject.lookup_by_key(:german) }

      include_context "with preferred teaching subject set in welcome_guide and mailinglist"

      specify "returns the subject from the query param" do
        expect(subject).to eql("German")
      end
    end
  end

  describe "#consideration_journey_stage_id" do
    before do
      allow(session).to receive(:dig).with("welcome_guide", "consideration_journey_stage_id").and_return(nil)
      allow(session).to receive(:dig).with("mailinglist", "consideration_journey_stage_id").and_return(nil)
      consideration_journey_stage_id
    end

    specify "checks the welcome guide and mailing list session values" do
      expect(session).to have_received(:dig).with("welcome_guide", "consideration_journey_stage_id")
      expect(session).to have_received(:dig).with("mailinglist", "consideration_journey_stage_id")
    end
  end
end
