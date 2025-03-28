require "rails_helper"

RSpec.describe WelcomeHelper, type: :helper do
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

  describe "#show_welcome_guide?" do
    degree_statuses = [
      Crm::OptionSet.lookup_by_key(:degree_status, :graduate_or_postgraduate),
      Crm::OptionSet.lookup_by_key(:degree_status, :not_yet_i_m_studying_for_one),
      Crm::OptionSet.lookup_by_key(:degree_status, :i_don_t_have_a_degree_and_am_not_studying_for_one)
    ]

    consideration_journey_stages = [
      Crm::OptionSet.lookup_by_key(:consideration_journey_stages, :it_s_just_an_idea),
      Crm::OptionSet.lookup_by_key(:consideration_journey_stages, :i_m_very_sure_and_think_i_ll_apply)
    ]

    truthy_combinations = [
      [
        Crm::OptionSet.lookup_by_key(:degree_status, :graduate_or_postgraduate),
        Crm::OptionSet.lookup_by_key(:consideration_journey_stages, :it_s_just_an_idea)
      ]
    ]

    all_combinations = degree_statuses.product(consideration_journey_stages)

    context "with a matching combination" do
      truthy_combinations.each do |degree_status, consideration_stage|
        it "returns true for degree_status: #{degree_status} and consideration_stage: #{consideration_stage}" do
          expect(show_welcome_guide?(degree_status: degree_status, consideration_journey_stage: consideration_stage)).to be true
        end
      end
    end

    context "with a non-matching combination" do
      all_combinations.each do |degree_status, consideration_stage|
        unless truthy_combinations.include?([degree_status, consideration_stage])
          it "returns false for degree_status: #{degree_status} and consideration_stage: #{consideration_stage}" do
            expect(show_welcome_guide?(degree_status: degree_status, consideration_journey_stage: consideration_stage)).to be false
          end
        end
      end
    end
  end

    describe '#high_commitment?' do
    it 'returns true for consideration_journey_stage 222750003' do
      expect(high_commitment?(consideration_journey_stage: 222750003)).to be true
    end

    it 'returns false for other consideration_journey_stage values' do
      expect(high_commitment?(consideration_journey_stage: 123456789)).to be false
    end
  end

  describe '#low_commitment?' do
    it 'returns true for consideration_journey_stage 222750000' do
      expect(low_commitment?(consideration_journey_stage: 222750000)).to be true
    end

    it 'returns false for other consideration_journey_stage values' do
      expect(low_commitment?(consideration_journey_stage: 123456789)).to be false
    end
  end

  describe '#graduate?' do
    it 'returns true for degree_status 222750000' do
      expect(graduate?(degree_status: 222750000)).to be true
    end

    it 'returns false for other degree_status values' do
      expect(graduate?(degree_status: 123456789)).to be false
    end
  end

  describe '#studying?' do
    it 'returns true for degree_status 222750006' do
      expect(studying?(degree_status: 222750006)).to be true
    end

    it 'returns false for other degree_status values' do
      expect(studying?(degree_status: 123456789)).to be false
    end
  end

  describe '#no_degree?' do
    it 'returns true for degree_status 222750004' do
      expect(no_degree?(degree_status: 222750004)).to be true
    end

    it 'returns false for other degree_status values' do
      expect(no_degree?(degree_status: 123456789)).to be false
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

      let(:subject_id) { Crm::TeachingSubject.lookup_by_key(:chemistry) }

      specify "returns the correct subject" do
        expect(subject).to eql("chemistry")
      end
    end

    context "when stored in the mailinglist session store" do
      context "when the subject name is a common noun" do
        %i[art_and_design biology chemistry science languages_other maths physics].each do |subject_key|
          describe "#{subject_key} is lowercased" do
            let(:subject_id) { Crm::TeachingSubject.lookup_by_key(subject_key) }

            include_context "with preferred teaching subject set in welcome_guide"

            it { is_expected.to eql(Crm::TeachingSubject.lookup_by_uuid(subject_id).downcase) }
          end
        end
      end

      context "when the subject name is a proper noun" do
        %i[english german spanish french].each do |subject_key|
          describe "#{subject_key} is not lowercased" do
            let(:subject_id) { Crm::TeachingSubject.lookup_by_key(subject_key) }

            include_context "with preferred teaching subject set in welcome_guide"

            it { is_expected.to eql(Crm::TeachingSubject.lookup_by_uuid(subject_id)) }
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

      it { is_expected.to eql("Physics") }
    end
  end

  describe "#subject_teachers" do
    let(:subject_id) { physics_uuid }

    context "when subject is set in the session" do
      include_context "with preferred teaching subject set in welcome_guide"
      subject { subject_teachers }

      it { is_expected.to eql("physics teachers") }
    end

    context "when no subject is set" do
      subject { subject_teachers }

      it { is_expected.to eql("teachers") }
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
      let(:subject_id) { Crm::TeachingSubject.lookup_by_key(:languages_other) }

      include_context "with preferred teaching subject set in welcome_guide"

      specify "returns the subject from the query param" do
        expect(subject).to eql("languages (other)")
      end
    end

    context "when the subject id is in the mailinglist session store" do
      let(:subject_id) { Crm::TeachingSubject.lookup_by_key(:german) }

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
