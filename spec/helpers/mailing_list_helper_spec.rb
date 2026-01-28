require "rails_helper"

RSpec.describe MailingListHelper, type: :helper do
  let(:physics_uuid) { Crm::TeachingSubject.lookup_by_key(:physics) }

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

  describe "attributes" do
    it "responds to key mailing list attributes" do
      expect(helper).to respond_to(
        :degree_status, :graduation_year,
        :citizenship, :visa_status, :location,
        :situation, :consideration_journey_stage, :teaching_subject
      )
    end
  end

  describe "#ml_uk_citizen?" do
    subject { ml_uk_citizen? }

    context "when a UK citizen" do
      before { @citizenship = build(:citizenship, :uk_citizen) }

      it { is_expected.to be true }
    end

    context "when a non-UK citizen" do
      before { @citizenship = build(:citizenship, :non_uk_citizen) }

      it { is_expected.to be false }
    end
  end

  describe "#ml_career_changer?" do
    subject { ml_career_changer? }

    context "when a career changer" do
      before { @situation = build(:situation, :change_career) }

      it { is_expected.to be true }
    end

    context "when a teaching assistant" do
      before { @situation = build(:situation, :teaching_assistant) }

      it { is_expected.to be false }
    end
  end

  describe "#ml_has_degree?" do
    subject { ml_has_degree? }

    context "when a graduate" do
      before { @degree_status = build(:degree_status, :graduate_or_postgraduate) }

      it { is_expected.to be true }
    end

    context "when studying for a degree" do
      before { @degree_status = build(:degree_status, :not_yet_im_studying) }

      it { is_expected.to be false }
    end
  end

  describe "#ml_degree_in_progress?" do
    subject { ml_degree_in_progress? }

    context "when a graduate" do
      before { @degree_status = build(:degree_status, :graduate_or_postgraduate) }

      it { is_expected.to be false }
    end

    context "when studying for a degree" do
      before { @degree_status = build(:degree_status, :not_yet_im_studying) }

      it { is_expected.to be true }
    end
  end

  describe "#ml_no_degree?" do
    subject { ml_no_degree? }

    context "when a graduate" do
      before { @degree_status = build(:degree_status, :graduate_or_postgraduate) }

      it { is_expected.to be false }
    end

    context "when does not have a degree" do
      before { @degree_status = build(:degree_status, :no_degree) }

      it { is_expected.to be true }
    end
  end

  describe "#ml_high_commitment?" do
    subject { ml_high_commitment? }

    context "when high committment" do
      before { @consideration_journey_stage = build(:consideration_journey_stage, :very_sure_and_will_apply) }

      it { is_expected.to be true }
    end

    context "when low committment" do
      before { @consideration_journey_stage = build(:consideration_journey_stage, :just_an_idea) }

      it { is_expected.to be false }
    end
  end

  describe "#ml_graduated_and_exploring_career_options?" do
    subject { ml_graduated_and_exploring_career_options? }

    context "when graduated and exploring my career options" do
      before { @situation = build(:situation, :graduated) }

      it { is_expected.to be true }
    end

    context "when a teaching assistant" do
      before { @situation = build(:situation, :teaching_assistant) }

      it { is_expected.to be false }
    end
  end

  describe "#ml_explore_subject" do
    subject { ml_explore_subject }

    before { @teaching_subject = build(:teaching_subject, subject_key: subject_key) }

    context "when the teaching subject is Biology" do
      let(:subject_key) { :biology }

      it { is_expected.to have_link(href: "/life-as-a-teacher/explore-subjects/biology") }
    end

    context "when the teaching subject is Drama" do
      let(:subject_key) { :drama }

      it { is_expected.to have_link(href: "/life-as-a-teacher/explore-subjects/drama") }
    end

    context "when the teaching subject is German" do
      let(:subject_key) { :german }

      it { is_expected.to have_link(href: "/life-as-a-teacher/explore-subjects/languages") }
    end

    context "when the teaching subject is Maths" do
      let(:subject_key) { :maths }

      it { is_expected.to have_link(href: "/life-as-a-teacher/explore-subjects/maths") }
    end

    context "when the teaching subject is Primary" do
      let(:subject_key) { :primary }

      it { is_expected.to have_link(href: "/life-as-a-teacher/age-groups-and-specialisms/primary") }
    end

    context "when the teaching subject is Classics" do
      let(:subject_key) { :classics }

      it { is_expected.to be_nil }
    end
  end

  describe "#ml_explore_subject?" do
    subject { ml_explore_subject? }

    before { @teaching_subject = build(:teaching_subject, subject_key: subject_key) }

    context "when the teaching subject is Biology" do
      let(:subject_key) { :biology }

      it { is_expected.to be true }
    end

    context "when the teaching subject is Classics" do
      let(:subject_key) { :classics }

      it { is_expected.to be false }
    end
  end
end
