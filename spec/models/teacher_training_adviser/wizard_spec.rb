require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Wizard do
  describe ".steps" do
    subject { described_class.steps }

    it do
      expect(subject).to eql [
        TeacherTrainingAdviser::Steps::Identity,
        GITWizard::Steps::Authenticate,
        TeacherTrainingAdviser::Steps::AlreadySignedUp,
        TeacherTrainingAdviser::Steps::ReturningTeacher,
        TeacherTrainingAdviser::Steps::HasTeacherId,
        TeacherTrainingAdviser::Steps::PreviousTeacherId,
        TeacherTrainingAdviser::Steps::StageTaught,
        TeacherTrainingAdviser::Steps::SubjectTaught,
        TeacherTrainingAdviser::Steps::HaveADegree,
        TeacherTrainingAdviser::Steps::NoDegree,
        TeacherTrainingAdviser::Steps::StageOfDegree,
        TeacherTrainingAdviser::Steps::WhatSubjectDegree,
        TeacherTrainingAdviser::Steps::WhatDegreeClass,
        TeacherTrainingAdviser::Steps::StageInterestedTeaching,
        TeacherTrainingAdviser::Steps::GcseMathsEnglish,
        TeacherTrainingAdviser::Steps::RetakeGcseMathsEnglish,
        TeacherTrainingAdviser::Steps::GcseScience,
        TeacherTrainingAdviser::Steps::RetakeGcseScience,
        TeacherTrainingAdviser::Steps::QualificationRequired,
        TeacherTrainingAdviser::Steps::SubjectInterestedTeaching,
        TeacherTrainingAdviser::Steps::StartTeacherTraining,
        TeacherTrainingAdviser::Steps::SubjectLikeToTeach,
        TeacherTrainingAdviser::Steps::DateOfBirth,
        TeacherTrainingAdviser::Steps::UkOrOverseas,
        TeacherTrainingAdviser::Steps::UkAddress,
        TeacherTrainingAdviser::Steps::UkTelephone,
        TeacherTrainingAdviser::Steps::OverseasCountry,
        TeacherTrainingAdviser::Steps::OverseasTelephone,
        TeacherTrainingAdviser::Steps::UkCallback,
        TeacherTrainingAdviser::Steps::OverseasTimeZone,
        TeacherTrainingAdviser::Steps::OverseasCallback,
        TeacherTrainingAdviser::Steps::ReviewAnswers,
      ]
    end
  end

  describe "instance methods" do
    subject { described_class.new wizardstore, "review_answers" }

    let(:store) do
      {
        "email" => "email@address.com",
        "first_name" => "Joe",
        "last_name" => "Joseph",
        "type_id" => 123,
        "degree_options" => "equivalent",
        "callback_offered" => true,
      }
    end
    let(:wizardstore) { GITWizard::Store.new store, {} }

    describe "#time_zone" do
      it "defaults to London" do
        expect(subject.time_zone).to eq("London")
      end

      it "returns the time_zone from the store" do
        wizardstore["time_zone"] = "Hawaii"
        expect(subject.time_zone).to eq("Hawaii")
      end
    end

    describe "#export_data" do
      it "sets country_id when uk_or_overseas is UK" do
        wizardstore["uk_or_overseas"] = TeacherTrainingAdviser::Steps::UkOrOverseas::OPTIONS[:uk]
        wizardstore["country_id"] = "abc-123"
        expect(subject.export_data).to include({ "country_id" => described_class::UK_COUNTRY_ID })
      end

      it "does nothing when uk_or_overseas is not UK" do
        wizardstore["uk_or_overseas"] = TeacherTrainingAdviser::Steps::UkOrOverseas::OPTIONS[:overseas]
        wizardstore["country_id"] = "abc-123"
        expect(subject.export_data).to include({ "country_id" => wizardstore["country_id"] })
      end

      it "sets the inferred initial_teacher_training_year_id if nil" do
        allow_any_instance_of(TeacherTrainingAdviser::Steps::StartTeacherTraining).to receive(:inferred_year_id).and_return(123_456)
        expect(subject.export_data).to include({ "initial_teacher_training_year_id" => 123_456 })
      end

      it "does not overwrite the current initial_teacher_training_year_id if present" do
        wizardstore["initial_teacher_training_year_id"] = 789_012
        allow_any_instance_of(TeacherTrainingAdviser::Steps::StartTeacherTraining).to receive(:inferred_year_id).and_return(123_456)
        expect(subject.export_data).to include({ "initial_teacher_training_year_id" => 789_012 })
      end
    end

    describe "#complete!" do
      let(:request) do
        GetIntoTeachingApiClient::TeacherTrainingAdviserSignUp.new({
          email: "email@address.com",
          first_name: "Joe",
          last_name: "Joseph",
          type_id: 123,
          accepted_policy_id: "123",
        })
      end

      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeacherTrainingAdviserApi).to \
          receive(:sign_up_teacher_training_adviser_candidate).with(request)

        allow(subject).to receive_messages(valid?: true, can_proceed?: true)

        subject.complete!
      end

      it { is_expected.to have_received(:valid?) }
      it { is_expected.to have_received(:can_proceed?) }

      it "prunes the store leaving data required to render the completion page" do
        expect(store).to eql({ "type_id" => 123, "degree_options" => "equivalent", "callback_offered" => true, "first_name" => "Joe" })
      end
    end

    describe "#exchange_access_token" do
      let(:totp) { "123456" }
      let(:request) { GetIntoTeachingApiClient::ExistingCandidateRequest.new }
      let(:response) { GetIntoTeachingApiClient::TeacherTrainingAdviserSignUp.new }

      before do
        allow_any_instance_of(GetIntoTeachingApiClient::TeacherTrainingAdviserApi).to \
          receive(:exchange_access_token_for_teacher_training_adviser_sign_up)
          .with(totp, request) { response }
      end

      it "calls exchange_access_token_for_teacher_training_adviser_sign_up" do
        expect(subject.exchange_access_token(totp, request)).to eq(response)
      end
    end
  end
end
